# template_python
To use this template, execute the scripts provided in the 'scripts/setup' folder in the order they are numbered (see [Setup](#setup)).
This will create a new Python project with a custom name and Python version.
The result will be identical to the structure of this project (see [Content](#content) for a detailed description).
Every  to the remote repository will trigger a linting (all code) and testing process (code in ).

## Setup
Run the following scripts:
01. `./scripts/setup/01_setup_project.sh <project_name> <python_version>` - Create a new Python project with a custom name and Python version, altering the current project files.
02. `./scripts/setup/02_setup_build_docker.sh` - Build the Docker image and installs the package therein.
03. `./scripts/setup/03_setup_run_docker.sh` - Run the Docker container and keep it running. This script might need to be run again after a restart.

## Usage
Run `./scripts/setup/docker_exec.sh <command>` to run a command inside the Docker container and `./scripts/setup/bump_version.sh` to increment the package version.

## Content
```bash
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
├── template_python # Source code folder
│   ├── __init__.py # Package __init__ file containing the version
└── tests # Test scripts folder
    └── test_load_package.py # Test script to check if package loads
```
