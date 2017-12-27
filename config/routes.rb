Rails.application.routes.draw do

  if Rails.env.development?
    scope module: 'docs' do
      namespace :v1 do
        get 'apidocs' => 'docs#index'
        get '/docs' => 'docs#publish'
      end
    end
  end

  # constraints subdomain: 'api' do
  	scope module: 'api' do
  		namespace :v1 do
        devise_for :users, skip: :all
        devise_scope :v1_user do
          post 'sign_up' => 'registrations#create'
          post 'sign_in' => 'sessions#create'
          delete 'sign_out' => 'sessions#destroy'
          post 'confirmation' => 'confirmations#create'
          get 'confirmation' => 'confirmations#show'
          get 'users' => 'sessions#index'
        end

        match 'authorize/:provider/callback',
          to: 'omniauth_callbacks#create',
          via: [:get, :post],
          constraints: { provider: /facebook/ }

  		end
	  end

    # Let’s encrypt
    get '/.well-known/acme-challenge/:id' => 'application#letsencrypt'


  # end
end
