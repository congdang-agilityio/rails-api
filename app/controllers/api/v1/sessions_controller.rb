module Api::V1
  class SessionsController < Devise::SessionsController
    include Deviseable

    skip_before_action :parse_user_from_token, only: [:create, :index]
    skip_before_action :authenticate_user_from_token!, only: [:create, :index]
    skip_before_action :verify_signed_out_user, only: [:destroy]

    def index
      # everything is ok, return the token
      render json: User.all
    end

    def create
      user = User.find_for_database_authentication(email: params[:email])

      # raising invalid login error
      raise Devise::InvalidLogin unless user.present? && user.valid_password?(params[:password])
      raise Devise::Unverified unless user.is_activated

      # trigger sign in
      sign_in user, store: false

      # everything is ok, return the token
      render json: user, serializer: serializer
    end

    # DELETE /users/sign_out
    def destroy
      Devise.sign_out_all_scopes ? sign_out : sign_out(@current_user)
      render status: :ok, json: { success: true }
    end

    private
    def serializer
      AuthenticatedUserSerializer
    end
  end
end
