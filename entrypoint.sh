#!/usr/bin/env bash

env | egrep -v "^(#|;| |PATH|SHLVL|HOSTNAME|DOCKER_*)" | awk '$1 ~ /^\w+=/' | xargs -0 > docker-run-action.env

if [ ! -z $INPUT_USERNAME ];
then echo $INPUT_PASSWORD | docker login $INPUT_REGISTRY -u $INPUT_USERNAME --password-stdin
fi

if [ ! -z $INPUT_DOCKER_NETWORK ];
then INPUT_OPTIONS="$INPUT_OPTIONS --network $INPUT_DOCKER_NETWORK"
fi

# TODO: Make this only visbile if user selects debug workflow run
echo "Input Options: $INPUT_OPTIONS"
echo "Input Run: $INPUT_RUN"
echo "Input Shell: $INPUT_SHELL"

exec docker run --env-file docker-run-action.env -v "/var/run/docker.sock":"/var/run/docker.sock" $INPUT_OPTIONS --entrypoint=$INPUT_SHELL $INPUT_IMAGE -c "${INPUT_RUN//$'\n'/;}"
