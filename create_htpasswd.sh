#!/bin/sh
printenv;
# Check if the required environment variables are set
if [ -z "$BASIC_AUTH_USER" ] || [ -z "$BASIC_AUTH_PASSWORD" ]; then
  echo "Error: BASIC_AUTH_USER and BASIC_AUTH_PASSWORD environment variables must be set."
  exit 1
fi

# Generate the htpasswd file
htpasswd -bc /etc/nginx/.htpasswd $BASIC_AUTH_USER $BASIC_AUTH_PASSWORD