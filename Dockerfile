FROM ruby:2.4.2-alpine3.4

RUN mkdir /gems
ENV BUNDLE_PATH /gems
ADD Gemfile Gemfile.lock /app/
WORKDIR /app

RUN [ "bundle", "install", "--path", "/gems" ]
ADD . /app
EXPOSE 4567

CMD [ "bundle", "exec", "ruby", "config.ru" ]
