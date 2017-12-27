require "spec_helper"
require "bunny"
describe Api::V1::ConfirmationsController, :type => :api do

  # Rspec for POST /v1/confirmation api
  describe "#confirmation", :request_verify_code do

    context 'Let signup a user' do
      before {
        post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: Faker::Internet.email, phone_number: "2343333457",  password: Faker::Crypto.sha256}
        # clear
        conn = Bunny.new
        conn.start
        queue = conn.channel.queue "tize.sms"
        queue.delete
        conn.close
      }

      it 'should return a new user' do

        expect(last_response.status).to eq 200
      end

      it 'now send a code to cell phone of new user and ' do
        post '/v1/confirmation', {phone_number: "2343333457"}
        expect(last_response.status).to eq 200

        # check the queue name 'tize.sms' is exists
        # and there is a message on it
        conn = Bunny.new
        conn.start

        expect(conn.queue_exists?("tize.sms")).to be_truthy
        queue = conn.channel.queue "tize.sms"
        expect(queue.message_count).to eq(1)
        conn.close
      end

      context 'but when provide a not existing phone number' do
        it 'it should return status code is 401' do
          post '/v1/confirmation', {phone_number: "2343333456"}
          expect(last_response.status).to eq 401
        end
      end

    end
  end

  # Rspec GET for /v1/confirmation api
  describe "#verify_account", :verify_account do

    context 'Let signup a user' do
      before {
        post '/v1/sign_up', {first_name: Faker::Name.name, last_name: Faker::Name.name, email: 'test@mytize.co', phone_number: "2343333457",  password: 'abc@123456789'}
        # clear the queue
        conn = Bunny.new
        conn.start
        queue = conn.channel.queue "tize.sms"
        queue.delete
        conn.close
      }

      it 'should return a new user' do
        expect(last_response.status).to eq 200
      end

      it 'now send a code to cell phone of new user and ' do
        post '/v1/confirmation', {phone_number: "2343333457"}
        expect(last_response.status).to eq 200

      end

      context 'then call the verify account with correct phone number and code' do
        let(:code) {Faker::Number.number(6)}
        it 'should return status code is 200' do
          user = User.find_by phone_number: "2343333457"
          user.verify_code = code
          user.save
          get 'v1/confirmation', {verify_code: code}
          expect(last_response.status).to eq 200
        end

      end

      context 'but when provide an invalid code' do
        let(:code) {Faker::Number.number(6)}
        it 'should return an error with status not equal 200' do

          user = User.find_by phone_number: "2343333457"
          user.verify_code = code
          user.save

          get 'v1/confirmation', {verify_code: "123"}
          expect(last_response.status).to_not eq 200
        end

      end
    end
  end
end
