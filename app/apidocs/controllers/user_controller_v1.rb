require "#{Rails.root}/app/apidocs/modules/swagger_responses.rb"
class UsersControllerV1
  include Swagger::Blocks
  ##############################################
  # API DOCUMENT
  ##############################################
  include SwaggerResponses
  # document for signup api
  swagger_path '/v1/sign_up' do
    operation :post do
      extend SwaggerResponses::AuthenticationError
      extend SwaggerResponses::InvalidInputError
      extend SwaggerResponses::UnacceptedError
      key :description, 'Create new user'
      key :operationId, 'addUser'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'User'
      ]
      # security do
      #   key :api_key, []
      # end
      parameter do
        key :name, :user
        key :in, :body
        key :description, 'User information'
        key :required, true
        schema do
          key :'$ref', :UserInput
        end
      end
      response 200 do
        key :description, 'User object'
        schema do
          key :'$ref', :User
        end
      end

      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  # Document for request verify code api
  swagger_path '/v1/confirmation' do
    operation :post do
      extend SwaggerResponses::AuthenticationError
      extend SwaggerResponses::InvalidInputError
      extend SwaggerResponses::UnacceptedError
      key :description, 'Request verify code'
      key :operationId, 'requestCode'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :phone_number
        key :in, :query
        key :description, 'Phone number'
        key :required, true
        schema do
          key :type, :string
          key :example, '(234)333 3456'
        end
      end

      response 200 do
        key :description, 'Sending response'
        schema do
          key :type, :string
          key :example, 'A SMS is sent to your phone'
        end
      end

      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # Document for verify account api
  swagger_path '/v1/confirmation' do
    operation :get do
      extend SwaggerResponses::AuthenticationError
      extend SwaggerResponses::InvalidInputError
      extend SwaggerResponses::UnacceptedError
      key :description, 'Verify account'
      key :operationId, 'verifyAccount'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :verify_code
        key :in, :query
        key :description, 'Verify code'
        key :required, true
        schema do
          key :type, :string
          key :example, '123456'
        end
      end

      response 200 do
        key :description, 'Verify response'
        schema do
          key :'$ref', :User
        end
      end

      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  # Document for signin api
  swagger_path '/v1/sign_in' do
    operation :post do
      extend SwaggerResponses::AuthenticationError
      extend SwaggerResponses::InvalidInputError
      extend SwaggerResponses::UnacceptedError
      key :description, 'User Logoin'
      key :operationId, 'userLogin'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'User'
      ]
      parameter do
        key :name, :email
        key :in, :query
        key :description, 'Email'
        key :required, true
        schema do
          key :type, :string
          key :example, 'tester@agilityio.com'
        end
      end
      parameter do
        key :name, :password
        key :in, :query
        key :description, 'Password'
        key :required, true
        schema do
          key :type, :string
          key :example, '7384&^^%'
        end
      end

      response 200 do
        key :description, 'Login response'
        schema do
          key :required, [:auth_token]
          property :auth_token do
            key :type, :string
            key :example, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyNn0.3GG5Y2RjDLrVMFmqMfxEdOOntXw2-TT8WvolNCTgMoQ"
          end
          key :'$ref', :User
        end
      end

      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end


  end
  swagger_path '/v1/sign_out' do
    operation :delete do
      extend SwaggerResponses::AuthenticationError
      extend SwaggerResponses::InvalidInputError
      extend SwaggerResponses::UnacceptedError
      key :description, 'User Logout'
      key :operationId, 'userLogout'
      key :produces, [
        'application/json'
      ]
      key :tags, [
        'User'
      ]
      response 200 do
        key :description, 'Login response'
        schema do
          key :required, [:success]
          property :success do
            key :type, :string
            key :example, "true"
          end
        end
      end

      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
end
