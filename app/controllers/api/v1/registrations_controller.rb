module Api::V1
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    # /v1/users
    #
    # Simple sign up with email and password
    # Auto login after signed up successful and return jwt token.

    #   parameters:
    #     - first_name: string
    #     - last_name: string
    #     - email: string
    #     - phone_number: string
    #     - date_of_birth: datetime
    #     - password: string
    #
    #   response:
    #     user: Object

    def create
      user = User.new user_params
      if user.save
        render json: user, serializer: serializer
      else
        render json: { errors: user.errors }, status: :not_acceptable
      end
    end


    private
    # collect user parameter for sign up
    def user_params
      params.permit(:first_name, :last_name, :email, :phone_number, :date_of_birth, :password)
    end

    def serializer
      UserSerializer
    end

  end
end
