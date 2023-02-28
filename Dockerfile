FROM ruby:3.1.3-slim
ENV RAILS_ROOT=/usr/app/${APP_NAME}
ENV RAILS_ENV=${RAILS_ENV}
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client libproj-dev nodejs less libgeos-dev
RUN mkdir -p \$RAILS_ROOT/tmp/pids
WORKDIR \$RAILS_ROOT
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN  bundle install
COPY . .
EXPOSE 3000
