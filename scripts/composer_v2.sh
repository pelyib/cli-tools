#!/usr/bin/env bash

# @see https://hub.docker.com/r/composer/composer
docker run --rm --interactive --tty \
  --env COMPOSER_HOME \
  --volume ${COMPOSER_HOME:-$HOME/.composer}:${COMPOSER_HOME} \
  --volume $PWD:/app \
  composer/composer:2 "$@"