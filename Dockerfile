###
### This image is used for CI only.. it is not deployed
###
FROM bitwalker/alpine-elixir:1.8.0

# Install build dependencies
RUN mix local.hex --force
RUN mix local.rebar --force
RUN apk --update --no-cache add build-base

# Create working directory
ADD . /app
WORKDIR /app

# Install hex packages
RUN mix deps.get
