#!/bin/bash

# Default .env
ENV_FILE="config/.env"

# Check if the first argument is --env-file
if [[ "$1" == "--env-file" ]]; then
    ENV_FILE="$2"
    shift 2
fi
echo "Sourcing from $ENV_FILE"
source $ENV_FILE

# Extract the current version from the __init__.py file
echo "Extracting current version from $PROJECT_NAME/__init__.py"
current_version=$(sed -n "s/__version__ = '\(.*\)'/\1/p" $PROJECT_NAME/__init__.py)
echo "Current version: $current_version"

# Parse the version into major, minor, and patch components
IFS='.' read -r major minor patch <<< "$current_version"
echo "Parsed version - Major: $major, Minor: $minor, Patch: $patch"

# Check if the --major or --minor flag is provided
if [[ "$1" == "--major" ]]; then
  echo "Incrementing major version"
  major=$((major + 1))
  minor=0
  patch=0
elif [[ "$1" == "--minor" ]]; then
  echo "Incrementing minor version"
  minor=$((minor + 1))
  patch=0
else
  echo "Incrementing patch version"
  patch=$((patch + 1))
fi

# Construct the new version
new_version="$major.$minor.$patch"
echo "New version: $new_version"

# Update the __init__.py file with the new version
echo "Updating $PROJECT_NAME/__init__.py with new version"
sed "s/__version__ = '$current_version'/__version__ = '$new_version'/" $PROJECT_NAME/__init__.py > $PROJECT_NAME/__init__.py.tmp
mv $PROJECT_NAME/__init__.py.tmp $PROJECT_NAME/__init__.py

# Commit the changes
echo "Committing changes"
git add $PROJECT_NAME/__init__.py
git commit -m "Bump version to $new_version"

# Add a git tag
echo "Creating git tag v$new_version"
git tag "v$new_version"

echo "Version bumped to $new_version, changes committed, and tag v$new_version created."