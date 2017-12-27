class JsonWebToken
  def self.encode(payload)
    if payload.present? && payload[:user_id].present?
      JWT.encode(payload, Rails.application.secrets.secret_key_jwt)
    else
      return "You need provide a paylod for encode"
    end
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_jwt)[0])
  rescue
    nil
  end

end
