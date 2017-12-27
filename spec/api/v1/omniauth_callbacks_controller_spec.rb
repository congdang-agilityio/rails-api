require 'spec_helper'

describe Api::V1::OmniauthCallbacksController, type: :controller do
  describe 'Facebook', :omniauth, :facebook do
    let(:provider) { 'facebook' }
    let(:params) do
      {
        provider: provider,
        user: {
          email: Faker::Internet.email,
          phone_number: Faker::Number.number(10)
        },
        auth: {
          provider: provider,
          uid: '12345',
          token: Faker::Crypto.sha256,
          expires_at: Time.now
        }
      }
    end
    let(:facebook_profile) do {
        email: params[:user][:email],
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }
    end

    describe 'Routes' do
      it {
        should route(:get, "/v1/authorize/#{provider}/callback")
          .to('api/v1/omniauth_callbacks#create', provider: provider)
      }

      it {
        should route(:post, "/v1/authorize/#{provider}/callback")
          .to('api/v1/omniauth_callbacks#create', provider: provider)
      }
    end

    describe 'Permit params' do
      before {
        allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me')
      }

      it do
        is_expected.to permit(:email, :phone_number).
          for(:create, params: { params: params }).
          on(:user)
      end

      it do
        is_expected.to permit(:provider, :uid, :token, :expires_at).
          for(:create, params: { params: params }).
          on(:auth)
      end
    end

    describe 'Koala' do
      it {
        allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me')

        expect_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me')
        post :create, params: params
      }

      it { is_expected.to rescue_from(Koala::KoalaError).with(:facebook_profile_error) }
    end

    describe 'Signup', type: :api do
      context 'with facebook profile', :now do
        it 'should respond ok' do
          allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me').and_return(facebook_profile)
          post "/v1/authorize/#{provider}/callback", params

          expect(last_response.content_type).to include('application/json')
          expect(last_response.status).to eq 200
        end

        describe 'should respond failure if any goes wrong' do
          before {
            allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me').and_raise(Koala::KoalaError)
            post "/v1/authorize/#{provider}/callback", params
          }

          it { expect(last_response.status).to eq 422 }
        end
      end

      context 'with valid info' do
        before {
          allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me').and_return(facebook_profile)
          post "/v1/authorize/#{provider}/callback", params
        }

        it 'should respond ok' do
          expect(last_response.content_type).to include('application/json')
          expect(last_response.status).to eq 200
        end
      end

      context 'with invalid info' do
        # TODO: add more validation failures
        before { |example|
          allow_any_instance_of(Koala::Facebook::API).to receive(:get_object).with('me').and_return(facebook_profile)

          unless example.metadata[:skip_before]
            params[:auth][:uid] = ''
            post "/v1/authorize/#{provider}/callback", params
          end
        }

        context 'ok if missing provider param', :skip_before do
          before {
            params[:auth][:provider] = ''
            post "/v1/authorize/#{provider}/callback", params
          }

          it 'should respond ok' do
            expect(last_response.content_type).to include('application/json')
            expect(last_response.status).to eq 200
          end
        end

        context 'failed if missing required field' do
          it {
            expect(last_response.content_type).to include('application/json')
            expect(last_response.status).to eq 422
          }

          it {
            expect(json["errors"]).to include_json(
              "identities.uid": [
                "can't be blank"
              ]
            )
          }
        end
      end
    end
  end
end
