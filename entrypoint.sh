#!/usr/bin/env bash

if [ ! -z $INPUT_USERNAME ];
then echo $INPUT_PASSWORD | docker login $INPUT_REGISTRY -u $INPUT_USERNAME --password-stdin > /dev/null 2>&1
fi

if [ ! -z $INPUT_DOCKER_NETWORK ];
then INPUT_OPTIONS="$INPUT_OPTIONS --network $INPUT_DOCKER_NETWORK"
fi


if [ "$INPUT_DEBUG" = true ] ; then
  echo "Input Options: $INPUT_OPTIONS"
  echo "Input Run: $INPUT_RUN"
  echo "Input Shell: $INPUT_SHELL"
fi

exec docker run --pull=always -v "/var/run/docker.sock":"/var/run/docker.sock" $INPUT_OPTIONS --entrypoint=$INPUT_SHELL $INPUT_IMAGE -c "${INPUT_RUN//$'\n'/;}"
