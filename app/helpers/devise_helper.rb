module DeviseHelper
  def invalid_token
    render json: {errors: [I18n.t('devise.failure.invalid_token')]}.to_json, status: :unauthorized
  end

  def invalid_login
    render json: {errors: 'Invalid email or passowrd'}.to_json, status: :unauthorized
  end

  def locked
    render json: {errors: [I18n.t('devise.failure.locked')]}.to_json, status: :unauthorized
  end

  def unverified
    render json: {errors: 'Your account has not been verified'}.to_json, status: :unauthorized
  end

  def unablesaved
    render json: {errors: 'Unable to save data'}.to_json, status: :unauthorized
  end

  def unknowuser
    render json: {errors: 'Can not found this user'}.to_json, status: :unauthorized
  end

  def send_password_reset_instructions
    render json: {messages: [I18n.t('devise.passwords.send_instructions')]}.to_json
  end

  class Devise::InvalidLogin < StandardError; end
  class Devise::InvalidToken < StandardError; end
  class Devise::Locked < StandardError; end
  class Devise::Unverified < StandardError; end
  class Devise::Unablesaved < StandardError; end
  class Devise::Unknowuser < StandardError; end
end
