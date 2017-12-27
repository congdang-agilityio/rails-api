require 'koala'

class Api::V1::OmniauthCallbacksController < ApplicationController
  rescue_from Koala::KoalaError, with: :facebook_profile_error

  def create
    # strict provider by called route
    params[:auth][:provider] = params[:provider]
    auth = auth_params

    # get Facebook profile
    profile = get_facebook_profile
    auth.merge! profile

    # create user and identity
    user = User.create_from_omniauth(auth, user_params)

    if user.persisted?
      render json: user
    elsif user.invalid?
      render json: { errors: user.errors }, status: :unprocessable_entity
    else
      render json: :nothing, status: :internal_server_error
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number)
  end

  def auth_params
    params.require(:auth).permit(:provider, :uid, :email, :first_name, :last_name, :token, :expires_at)
  end

  def get_facebook_profile
    # Need to enable `appsecret_proof` on Facebook App
    # https://developers.facebook.com/docs/graph-api/securing-requests
    graph = Koala::Facebook::API.new(auth_params[:token], ENV['FACEBOOK_APP_SECRET'])
    graph.get_object('me').to_h.slice(:email, :first_name, :last_name)
  end

  def facebook_profile_error(error)
    render json: {errors: [error.message]}.to_json, status: :unprocessable_entity
  end
end
