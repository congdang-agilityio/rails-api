class UserV1
  include Swagger::Blocks
  # define the swagger model
  swagger_schema :User do
    key :required, [:first_name, :last_name, :email, :phone_number ]
    property :id do
      key :type, :integer
      key :example, '123'
    end
    property :first_name do
      key :type, :string
      key :example, 'Cong'
    end
    property :last_name do
      key :type, :string
      key :example, 'Dang'
    end
    property :email do
      key :type, :string
      key :example, 'congdang@agilityio.com'
    end
    property :phone_number do
      key :type, :string
      key :example, '0907627151'
    end
    property :date_of_birth do
      key :type, :dateTime
      key :example, '08/07/1983'
    end
  end

  # define the swagger sample input
  swagger_schema :UserInput do
    allOf do
      schema do
        key :required, [:first_name, :last_name, :email, :phone_number,:date_of_birth, :password ]
        property :first_name do
          key :type, :string
          key :example, 'Cong'
        end
        property :last_name do
          key :type, :string
          key :example, 'Dang'
        end
        property :email do
          key :type, :string
          key :example, 'congdang@agilityio.com'
        end
        property :phone_number do
          key :type, :string
          key :example, '0907627151'
        end
        property :date_of_birth do
          key :type, :dateTime
          key :example, '01/01/1983'
        end
        property :password do
          key :type, :string
          key :example, (0...8).map { (65 + rand(26)).chr }.join
        end
      end
    end
  end

  swagger_schema :ErrorModel do
    key :required, [:code, :message]
    property :code do
      key :type, :integer
      key :format, :int32
      key :example, -1
    end
    property :message do
      key :type, :string
      key :example, "Unexpected error"
    end
  end
end
