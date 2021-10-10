FROM elixir:1.12.3-alpine as elixir-builder

WORKDIR /app
ENV MIX_ENV=dev
COPY . /app/
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

FROM node:lts-alpine3.12 as node-builder

COPY --from=elixir-builder /app /app
WORKDIR /app
RUN cd assets && npm install && npm rebuild node-sass

FROM elixir:1.12.3-alpine

COPY --from=node-builder /app /app
RUN apk update && apk add --update nodejs npm
RUN mix local.hex --force
WORKDIR /app
CMD ["/app/entrypoint.sh"]