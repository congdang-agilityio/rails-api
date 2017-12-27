# Rails.application.config.middleware.use OmniAuth::Builder do
#   options path_prefix: '/authorize'

#   provider :facebook,
#     ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
#     client_options: {
#       site: 'https://graph.facebook.com/v2.8',
#       authorize_url: 'https://www.facebook.com/v2.8/dialog/oauth'
#     }

#   on_failure { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
#   # on_failure { |env| Api::OmniauthCallbacksController.action(:failure).call(env) }
# end
