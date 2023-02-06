FROM ruby:3.0.0

ENV RAILS_ENV production
RUN mkdir /pixel_backend
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
WORKDIR /pixel_backend
ADD Gemfile /pixel_backend
ADD Gemfile.lock /pixel_backend
# ADD vendor/cache /pixel_backend/vendor/cache

ADD vendor/cache.tar.gz /pixel_backend/vendor/
ADD vendor/rspec_api_documentation.tar.gz /pixel_backend/vendor/ 

RUN bundle config set --local without 'development test'
RUN bundle install --local

ADD pixel_backend-*.tar.gz ./
ENTRYPOINT bundle exec puma