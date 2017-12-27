module SwaggerResponses
  module AuthenticationError
    def self.extended(base)
      base.response 401 do
        key :description, 'Not authorized'
        schema do
          key :'$ref', :AuthenticationError
        end
      end
    end
  end

  module InvalidInputError
    def self.extended(base)
      base.response 405 do
        key :description, 'Invalid User Input'
        schema do
          key :'$ref', :InvalidInputError
        end
      end
    end
  end

  module UnacceptedError
    def self.extended(base)
      base.response 406 do
        key :description, 'Unaccepted Error'
        schema do
          key :'$ref', :UnacceptedError
        end
      end
    end
  end

end