#!/bin/bash

# Default .env file path
ENV_FILE="config/.env"

# Check if the first argument is --env-file
if [[ "$1" == "--env-file" ]]; then
    ENV_FILE="$2"
    shift 2
fi

# The remaining arguments are the command to be executed
COMMAND="$@"

# Source the .env file
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "Env file not found: $ENV_FILE"
    exit 1
fi

docker compose --env-file "$ENV_FILE" exec $PROJECT_NAME $COMMAND
