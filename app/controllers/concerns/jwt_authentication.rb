module JwtAuthentication
  extend ActiveSupport::Concern

  def authenticate_jwt!
    OcfCollabJwtAuthenticator.new(token: bearer_token).token_data.present?
  rescue JWT::DecodeError => e
    render json: {
      error: e.message,
    }, status: :unauthorized
  end

  def bearer_token
    pattern = /^Bearer /i
    header = request.authorization
    header.gsub(pattern, "") if header&.match?(pattern)
  end
end
