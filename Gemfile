source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use Postgres as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'devise'
gem 'jwt'


# Omniauth strategies
gem 'omniauth-facebook'
gem 'koala', '~> 2.2'

# gem 'versionist'

gem 'dotenv-rails'
gem 'active_model_serializers', '~> 0.10.0'
gem "bunny", ">= 2.6.2"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  # Use Factory Girl for generating random test data
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rspec-json_expectations'
end

group :development do
  # api document
  gem 'swagger-blocks'
  gem 'annotate'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
