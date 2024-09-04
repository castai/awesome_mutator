#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
for cmd in helm git gh; do
    if ! command_exists "$cmd"; then
        echo "Error: $cmd is not installed. Please install it and try again."
        exit 1
    fi
done

# Configuration
CHART_DIR="../charts/awesome-mutator" 
GITHUB_USERNAME=castai
GITHUB_REPO=$(basename $(git rev-parse --show-toplevel))

# Ensure we're logged in to GitHub
if ! gh auth status &>/dev/null; then
    echo "Please log in to GitHub using 'gh auth login'"
    exit 1
fi

# Package the Helm chart
echo "Packaging Helm chart..."
helm package "$CHART_DIR"

# Get the packaged chart filename
CHART_PACKAGE=$(ls *.tgz | tail -n 1)

if [ -z "$CHART_PACKAGE" ]; then
    echo "Error: No packaged chart found."
    exit 1
fi

# Log in to GHCR
echo "Logging in to GHCR..."
echo $(gh auth token) | helm registry login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Push the Helm chart to GHCR
echo "Pushing Helm chart to GHCR..."
helm push "$CHART_PACKAGE" oci://ghcr.io/$GITHUB_USERNAME/awesome-mutator-charts

# Clean up the package file
rm "$CHART_PACKAGE"

echo "Helm chart successfully published to GHCR."
