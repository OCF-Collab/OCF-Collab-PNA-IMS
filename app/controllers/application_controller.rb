class ApplicationController < ActionController::API
  include JwtAuthentication

  before_action :authenticate_jwt!
end
