FROM ruby:2.6.0

RUN apt-get update -qq

RUN mkdir -p /src/mixtapes
WORKDIR /src/mixtapes

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install
COPY . .

# Hold the container open so you can check output and try new stuff!
CMD tail -f /dev/null