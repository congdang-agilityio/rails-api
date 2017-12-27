FROM ruby:2.3-alpine
# Update information about packages
RUN apk update
# Install bash in case you want to provide some work inside containe
# For example:
#     docker run -i -t name_of_your_image bash
RUN apk add bash

# g++ and make for gems building
RUN apk add g++ make

# Timezone data - required by Rails
RUN apk add tzdata



# Javscript runtime
RUN apk add postgresql-client postgresql-dev nodejs

#RUN apk add sqlite3 libsqlite3-dev

# Install bundler
RUN gem install bundler rake
# Install all gems and cache them
ENV APP_NAME auth

ENV APP_HOME /usr/src/$APP_NAME
RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# --- Add this to your Dockerfile ---
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/$APP_NAME-bundle

RUN bundle install

ADD . $APP_HOME

EXPOSE 3000

CMD rm -f tmp/pids/server.pid && export RAILS_ENV=development && bundle exec rails db:migrate && bundle exec rails s -b 0.0.0.0
