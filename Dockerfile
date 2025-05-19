FROM ruby:3.3.0

ENV RAILS_ENV=development \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    APP_HOME=/app

RUN apt-get update -qq && apt-get install -y \
  nodejs postgresql-client yarn

WORKDIR $APP_HOME

COPY Gemfile* ./
RUN bundle install

COPY . .

# Add entrypoint script and make it executable
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
