class OcfCollabJwtAuthenticator
  ISSUER = "OCF Collab"

  attr_reader :token

  def initialize(token:)
    @token = token
  end

  def token_data
    @token_data ||= JWT.decode(
      token,
      public_key,
      true,
      {
        iss: ISSUER,
        algorithm: header["alg"],
        verify_expiration: true,
        verify_iss: true,
      }
    )[0]
  end

  private

  def public_key
    @public_key ||= OpenSSL::PKey::RSA.new(ENV["JWT_PUBLIC_KEY"])
  end

  def header
    @header ||= JWT.decode(token, nil, false)[1]
  end
end
