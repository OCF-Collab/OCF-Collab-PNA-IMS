require 'test_helper'

class OcfCollabJwtAuthenticatorTest < ActiveSupport::TestCase
  describe OcfCollabJwtAuthenticator do
    subject do
      OcfCollabJwtAuthenticator.new(token: token)
    end

    describe ".token_data" do
      context "valid token" do
        let(:token) do
          file_fixture("jwt/valid_token_iat_1603621495").read
        end

        let(:token_issued_at) do
          Time.at(1603621495)
        end

        context "token not expired" do
          before do
            Timecop.freeze(token_issued_at + 1.minute)
          end

          after do
            Timecop.return
          end

          it "returns token data" do
            assert_equal "Local RNA", subject.token_data["rna"]["application"]
          end
        end

        context "token expired" do
          before do
            Timecop.freeze(token_issued_at + 2.hours)
          end

          after do
            Timecop.return
          end

          describe ".token_data" do
            it "raises JWT::ExpiredSignature" do
              assert_raise(JWT::ExpiredSignature) do
                subject.token_data
              end
            end
          end
        end
      end

      context "wrong signature token" do
        let(:token) do
          file_fixture("jwt/wrong_signature_token").read
        end

        it "raises JWT::ExpiredSignature" do
          assert_raise(JWT::VerificationError) do
            subject.token_data
          end
        end
      end
    end
  end
end
