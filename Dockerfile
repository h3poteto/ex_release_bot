FROM elixir:1.7.3-alpine

ADD . /var/opt/app

WORKDIR /var/opt/app

RUN set -ex && \
    mix deps.get && \
    mix release

RUN ["_build/dev/rel/release_bot/bin/release_bot foreground"]
