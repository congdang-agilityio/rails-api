class AuthenticatedUserSerializer < UserSerializer
  attributes :auth_token

  def auth_token
    JsonWebToken.encode({user_id: object.id, iat: object.current_sign_in_at.to_i})
  end
end
