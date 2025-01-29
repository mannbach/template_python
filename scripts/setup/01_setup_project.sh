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
cat <<EOL > $PROJECT_NAME/__init__.py
"""$PROJECT_NAME
"""

__version__ = '0.0.1'
EOL

# Create README.md
echo "Creating 'README.me'."
cat <<EOL > README.md
# $PROJECT_NAME
To use this template, execute the scripts provided in the 'scripts/setup' folder in the order they are numbered (see [Setup](#setup)).
This will create a new Python project with a custom name and Python version.
The result will be identical to the structure of this project (see [Content](#content) for a detailed description).
Every \`git push\` to the remote repository will trigger a linting (all code) and testing process (code in \`tests/\`).

## Setup
Run the following scripts:
01. \`./scripts/setup/01_setup_project.sh <project_name> <python_version>\` - Create a new Python project with a custom name and Python version, altering the current project files.
02. \`./scripts/setup/02_setup_build_docker.sh\` - Build the Docker image and installs the package therein.
03. \`./scripts/setup/03_setup_run_docker.sh\` - Run the Docker container and keep it running. This script might need to be run again after a restart.

## Usage
Run \`./scripts/setup/docker_exec.sh <command>\` to run a command inside the Docker container and \`./scripts/setup/bump_version.sh\` to increment the package version.

## Content
\`\`\`bash
├── Dockerfile # Dockerfile for the project
├── README.md # This readme
├── config # Configuration files. Default will be config/.env
│   └── sample.env # Sample environment file
├── data # Data files
├── docker-compose.yml # Docker compose configuration
├── output # Output files
├── pyproject.toml # Package configuration file
├── requirements.txt # Python package requirements
├── scripts # Scripts to be executed from the command line
│   └── setup # Project folder setup scripts
├── sketches # Folder to contain scripts that are not tracked by git
├── $PROJECT_NAME # Source code folder
│   ├── __init__.py # Package __init__ file containing the version
└── tests # Test scripts folder
    └── test_load_package.py # Test script to check if package loads
\`\`\`
EOL

# Create pyproject.toml
echo "Creating 'pyproject.toml'."
cat <<EOL > pyproject.toml
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT_NAME"
dynamic = ["version"]
description = "A new Python project."
readme = "README.md"
requires-python = ">=$PYTHON_VERSION"
dependencies = [
    # Add your project dependencies here
]

[tool.setuptools.packages.find]
where = ["."]

[tool.setuptools.dynamic]
version = {attr = "$PROJECT_NAME.__version__"}
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
cat <<EOL > config/.env
# Environment variables for template_python
PROJECT_NAME="$PROJECT_NAME"
PYTHON_VERSION="$PYTHON_VERSION"

# Application
PATH_CONTAINER_OUTPUT="/mnt/output/"
PATH_CONTAINER_DATA="/mnt/data/"

# Docker
## Path to where source data is located; can be absolute
PATH_HOST_DATA="./data/"
PATH_HOST_OUTPUT="./output/"
PATH_THIS_CONFIG="./config/sample.env"
EOL
cp config/.env config/sample.env

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