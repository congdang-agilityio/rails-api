require "#{Rails.root}/app/apidocs/models/user_v1.rb"
require "#{Rails.root}/app/apidocs/controllers/user_controller_v1.rb"
require "#{Rails.root}/app/apidocs/modules/swagger_responses.rb"
module Docs::V1
  class DocsController < ApplicationController
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: Rails.application.secrets.api_docs_username, password: Rails.application.secrets.api_docs_password, :except => :index

    include Swagger::Blocks
    swagger_root do
      key :swagger, '2.0'
      info do
        key :version, '1.0.0'
        key :title, 'Swagger TEST Authentication'
        key :description, 'The API set for TEST Authentication'
        key :termsOfService, 'https://mytize.co/termsOfService'
        contact do
          key :name, 'My TEST API Team'
        end
        license do
          key :name, 'MIT'
        end
      end
      security_definition :api_key do
        key :type, :apiKey
        key :name, :Authorization
        key :in, :header
      end
      tag do
        key :name, 'auth'
        key :description, 'Authentication Server'
        externalDocs do
          key :description, 'Find more info here'
          key :url, 'https://swagger.io'
        end
      end
      # key :host, 'localhost:3000'
      key :host, 'test-9548602.us-east-2.elb.amazonaws.com'
      key :basePath, '/'
      # key :host, 'localhost:3000'
      # key :basePath, '/'
      key :consumes, ['application/json', 'application/x-www-form-urlencoded']
      key :produces, ['application/json']
    end

    # A list of all classes that have swagger_* declarations.
    SWAGGERED_CLASSES = [
      SwaggerResponses,
      UsersControllerV1,
      UserV1,
      self,
    ].freeze

    def index
      render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    end
    def publish
      redirect_to '/swagger/index.html?url=/v1/apidocs'
    end
  end
end
