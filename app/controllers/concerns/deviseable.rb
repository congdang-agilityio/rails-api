module Deviseable
  extend ActiveSupport::Concern
  include Devise::Controllers::Helpers
  include DeviseHelper

  included do
    # Devise authentication
    before_action :parse_user_from_token
    before_action :authenticate_user_from_token!
    rescue_from Devise::InvalidToken, with: :invalid_token
    rescue_from Devise::InvalidLogin, with: :invalid_login
    rescue_from Devise::Locked, with: :locked
    rescue_from Devise::Unverified, with: :unverified
    rescue_from Devise::Unablesaved, with: :unablesaved
    rescue_from Devise::Unknowuser, with: :unknowuser
  end


  protected

  def authenticate_user_from_token!
    raise Devise::InvalidToken if @current_user.nil?
  end

  def with_verify_user
    raise Devise::Unverified unless @current_user.verified?
  end

  def parse_user_from_token
    auth_header = request.headers['Authorization']

    return if auth_header.blank?

    token = auth_header.split(' ').last

    payload = JsonWebToken.decode(token)

    @current_user = User.find_by_id(payload['user_id']) if payload.present?

    # Ensure the token is invalid if user signed-out before
    @current_user = nil if payload.present? && payload['iat'] != @current_user.current_sign_in_at.to_i

  rescue JWT::DecodeError
    @current_user = nil
  end

  def sign_out(resource_or_scope = nil)
    @current_user.update_attributes(current_sign_in_at: nil) if @current_user.present?
    super
  end

  def current_user
    @current_user
  end

end
