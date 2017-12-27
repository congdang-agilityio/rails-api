require "spec_helper"

describe Api::V1::SessionsController, :type => :api do

  # Rspec for POST /v1/user/sign_in api
  describe "#Sign In", :sign_in do
    context 'Let signup a user' do
      before { post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: 'test@mytize.co', phone_number: "2343333457",  password: 'abc@123456789'}}

      it 'should return a new user' do
        expect(last_response.status).to eq 200
      end

      it 'now send a code to cell phone of new user and ' do
        post '/v1/confirmation', {phone_number: "2343333457"}

        expect(last_response.status).to eq 200

      end

      context 'then call the verify account with correct phone number and code' do

        it 'should return status code is 200' do
          user = User.find_by phone_number: "2343333457"
          user.verify_code = '123456'
          user.save
          get 'v1/confirmation', {verify_code: '123456'}
          expect(last_response.status).to eq 200
        end

      end

      context "when provide correct email and password" do
        it 'should return a token' do
          user = User.find_by phone_number: "2343333457"
          user.verify_code = '123456'
          user.is_activated = true
          user.save
          post 'v1/sign_in', {email: 'test@mytize.co', password: 'abc@123456789'}
          expect(last_response.status).to eq 200
          expect(json['auth_token'].blank?).to_not eq true
        end
      end

      context "when provide incorrect email" do
        it 'should return a token' do
          user = User.find_by phone_number: "2343333457"
          user.verify_code = '123456'
          user.is_activated = true
          user.save
          post 'v1/sign_in', {email: 'test@mytize.com', password: 'abc@123456789'}
          expect(last_response.status).to eq 401
        end
      end

      context "when provide incorrect password" do
        it 'should return a token' do
          user = User.find_by phone_number: "2343333457"
          user.verify_code = '123456'
          user.is_activated = true
          user.save
          post 'v1/sign_in', {email: 'test@mytize.com', password: 'abc@12345678'}
          expect(last_response.status).to eq 401
        end
      end

      context "when the account is not activated" do
        it 'should return a token' do
          user = User.find_by phone_number: "2343333457"
          post 'v1/sign_in', {email: 'test@mytize.com', password: 'abc@12345678'}
          expect(last_response.status).to eq 401
        end
      end
    end
  end

  # Rspec for DELETE /v1/user/sign_out api
  describe "#SignOut", :sign_out do
    context "Let signup an user" do
      before {
        post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: 'test@mytize.co', phone_number: "2343333457",  password: 'abc@123456789'}
        user = User.find_by email: "test@mytize.co"
        user.is_activated = true
        user.save

        post 'v1/sign_in', {email: 'test@mytize.co', password: 'abc@123456789'}
        expect(last_response.status).to eq 200


      }

      context 'Give a loged in user' do
        it 'should the token valided' do
          expect(json['auth_token'].blank?).to_not eq true
        end
      end

      context 'Give a valid token to signout' do
        it 'allow to sign out' do
          header 'Authorization', "Beare #{json['auth_token']}"
          delete 'v1/sign_out'
          expect(last_response.status).to eq 200
        end
      end

      context "Give an invalid token to signout" do
        it 'should return an error' do
          header 'Authorization', "Beare balabla"
          delete 'v1/sign_out'
          expect(last_response.status).to eq 401
          expect(json['error'].blank?).to eq true
        end
      end
    end
  end
end
