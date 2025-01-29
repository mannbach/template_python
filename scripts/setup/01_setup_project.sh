#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_name> <python_version>"
    exit 1
fi

PROJECT_NAME=$1
PYTHON_VERSION=$2

# Create project directory
mkdir -p src

# Create __init__.py and add version
echo "Creating source code folder and 'src/__init__.py'."
touch src/__init__.py
echo "__version__ = '0.1'" > src/__init__.py

# Create README.md
echo "Creating 'README.me'."
cat <<EOL > README.md
# $PROJECT_NAME

## Description
A new Python project.

## Setup
Instructions to set up the project.

## Usage
Instructions to use the project.

## Content
Description of files and folders.
EOL

# Create setup.py
echo "Creating 'setup.py'."
cat <<EOL > setup.py
from setuptools import setup, find_packages

setup(
    name='$PROJECT_NAME',
    version='0.1',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
)
EOL

# Create Dockerfile
echo "Creating 'Dockerfile'."
cat <<EOL > Dockerfile
FROM python:$PYTHON_VERSION

WORKDIR /$PROJECT_NAME

COPY . .

# Install packages
RUN \\
    pip install --upgrade pip &&\\
    pip install -r requirements.txt &&\\
    pip install -e ./

# Keep running
CMD ["tail", "-f", "/dev/null"]
EOL

# Create docker-compose.yml
echo "Creating 'docker-compose.yml'."
cat <<EOL > docker-compose.yml
version: '3.8'

services:
  $PROJECT_NAME:
    build: .
    container_name: $PROJECT_NAME
    env_file:
      - 'config/$PROJECT_NAME.env'
    volumes:
      - .:/$PROJECT_NAME
    stdin_open: true # docker run -i
    tty: true        # docker run -t
EOL

# Create config/project_name.env
echo "Creating 'config/.env'."
cat <<EOL > config/.env
# Environment variables for $PROJECT_NAME
PROJECT_NAME="$PROJECT_NAME"
PYTHON_VERSION="$PYTHON_VERSION"

# Application
PATH_CONTAINER_OUTPUT="/mnt/output/"
PATH_CONTAINER_DATA="/mnt/data/"

# Docker
## Path to where source data is located; can be absolute
PATH_HOST_DATA="./data/"
PATH_HOST_OUTPUT="./output/"
PATH_THIS_CONFIG="./config/$PROJECT_NAME.env"
EOL

# Create a Python test that loads the package
echo "Creating 'tests/load_package.py'."
cat <<EOL > tests/load_package.py
import $PROJECT_NAME
import pytest

def test_load_package():
    assert $PROJECT_NAME
EOL

echo "Project $PROJECT_NAME setup completed."