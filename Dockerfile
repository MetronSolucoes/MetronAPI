FROM ruby:2.5.1

RUN wget --quiet -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq
RUN apt-get upgrade -qq && apt-get install -y apt-utils ca-certificates git postgresql-client nodejs yarn

WORKDIR /app

ENV TZ America/Sao_Paulo
ENV LANG "en_C.UTF-8"

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

RUN bundle install --quiet

RUN yarn install --no-install-recomendations

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]
