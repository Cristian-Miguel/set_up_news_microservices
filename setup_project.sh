#!/bin/bash

# Exit script on error
set -e

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found!"
    exit 1
fi

ROUTE_SHELL_FILES="setup_shell_file"

cd "$ROUTE_SHELL_FILES"

# Make the script executable
chmod +x service_setup.sh
chmod +x config_service_setup.sh
chmod +x generate_ssl.sh
chmod +x setup_ssl_in_service.sh

# Run service_setup.sh
echo "Running get-repos.sh..."
if ./service_setup.sh; then
  echo "service_setup.sh completed successfully!"
else
  echo "Error: get-repos.sh encountered an issue." >&2
  exit 1
fi

## cd "$ROUTE_SHELL_FILES"
# Run config_service_setup.sh
echo "Running config_service_setup.sh..."
if ./config_service_setup.sh; then
  echo ">>####### config_service_setup.sh completed successfully! #######<<"
  echo ""
  echo ""
else
  echo "Error: config_service_setup.sh encountered an issue." >&2
  exit 2
fi

## cd "$ROUTE_SHELL_FILES"
# Run generate_ssl.sh
echo "Running generate_ssl.sh..."
if ./generate_ssl.sh; then
  echo ">>####### generate_ssl.sh completed successfully! #######<<"
  echo ""
  echo ""
else
  echo "Error: generate_ssl.sh encountered an issue." >&2
  exit 2
fi

## cd "$ROUTE_SHELL_FILES"
# Run setup_ssl_in_service.sh
echo "Running setup_ssl_in_service.sh..."
if ./setup_ssl_in_service.sh; then
  echo ">>####### setup_ssl_in_service.sh completed successfully! #######<<"
  echo ""
  echo ""
else
  echo "Error: setup_ssl_in_service.sh encountered an issue." >&2
  exit 2
fi

echo "->   Setup process completed.   <-"