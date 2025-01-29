#!/bin/bash

# Check if optional environment file is provided and source it if it is.
# Otherwise, source from `../config/.env`.`
# Default .env file path
ENV_FILE="config/.env"

# Check if the first argument is --env-file
if [[ "$1" == "--env-file" ]]; then
    ENV_FILE="$2"
    shift 2
fi

# Build Docker image
echo "Building Docker image."
docker compose --env-file $ENV_FILE build