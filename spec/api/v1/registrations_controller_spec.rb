require "spec_helper"

describe Api::V1::RegistrationsController, :type => :api do

  # Rspec for POST /v1/user api
  describe '#Sign Up', :sign_up do
    # defining the sample data for user
    let(:first_name) {Faker::Name.name}
    let(:last_name) {Faker::Name.name}
    let(:email) {Faker::Internet.email}
    let(:phone_number) {Faker::Number.number(10) }
    let(:day_of_birth) {Faker::Date.backward(14)}
    let(:password) {Faker::Crypto.sha256}

    let(:user_params) { {first_name: first_name, last_name: last_name, email: email, phone_number: phone_number, password: password} }

    # the the correctly case
    context 'when user information are provided' do
      before { post '/v1/sign_up', user_params}

      context 'and they valid' do
        it 'the request is successful' do
          expect(last_response.status).to eq 200
        end

        it 'returns a user' do
          user = json
          expect(user.empty?).to eq false
        end
      end

      # missing password
      context 'but when password is not correctly' do
        it 'it should return the status code is 406' do
          post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email, password: '123'}
          expect(last_response.status).to eq 406
        end
      end

      # missing password
      context 'also when password is not provided' do
        it 'it should return the status code is 406' do
          post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email}
          expect(last_response.status).to eq 406
        end
      end

      # wrong email format
      context 'also when email is wrong format' do
        it 'it should return the status code is 406' do
          post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: "abc@123", password: Faker::Crypto.sha256}
          expect(last_response.status).to eq 406
        end
      end
    end
  end
end
