FROM elixir:1.7.3-alpine

ADD . /var/opt/app

WORKDIR /var/opt/app
ENV MIX_ENV=prod

RUN set -ex && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix release

CMD _build/dev/rel/release_bot/bin/release_bot foreground
