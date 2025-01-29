#!/bin/bash
# Run docker image

# Check if optional environment file is provided and source it if it is.
# Otherwise, source from `../config/.env`.`
if [ "$#" -eq 1 ]; then
    echo "Sourcing environment file: $1"
    ENV_FILE=$1
else
    echo "Sourcing environment file: ../../config/.env"
    ENV_FILE="../../config/.env"
fi

docker-compose --env-file $ENV_FILE up -d
