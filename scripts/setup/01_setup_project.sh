#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_name> <python_version>"
    exit 1
fi

PROJECT_NAME=$1
PYTHON_VERSION=$2

# Create project directory
mkdir -p $PROJECT_NAME

# Create __init__.py and add version
echo "Creating source code folder and '$PROJECT_NAME/__init__.py'."
touch $PROJECT_NAME/__init__.py
echo "__version__ = '0.0.1'" > $PROJECT_NAME/__init__.py

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

# Create pyproject.toml
echo "Creating 'pyproject.toml'."
cat <<EOL > pyproject.toml
[build-system]
requires = ["setuptools"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
dynamic = ["version"]
description = "A new Python project."
readme = "README.md"
requires-python = ">=3.10"
dependencies = [
    # Add your project dependencies here
]

[tool.setuptools.packages.find]
where = ["$PROJECT_NAME"]

[tool.setuptools.dynamic]
version = {attr = "__version__"}
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
services:
  $PROJECT_NAME:
    build: .
    container_name: $PROJECT_NAME
    env_file:
      - 'config/.env'
    volumes:
      - .:/$PROJECT_NAME
    stdin_open: true # docker run -i
    tty: true        # docker run -t
EOL

# Create config/.env
echo "Creating 'config/.env'."
cp config/sample.env config/.env

# Create a Python test that loads the package
echo "Creating 'tests/test_load_package.py'."
cat <<EOL > tests/test_load_package.py
"""Tests for checking build.
"""
import $PROJECT_NAME

def test_load_package():
    """Test whether import of package is successful.
    """
    assert $PROJECT_NAME
EOL

echo "Project $PROJECT_NAME setup completed."