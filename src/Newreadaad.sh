#!/bin/bash

# Set your environment variables
CLIENT_ID="your-client-id"
CLIENT_SECRET="your-client-secret"
TOKEN_URL="https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token"
SCOPE="https://graph.microsoft.com/.default"

# Read the values from variables (you can also export these variables and read using $CLIENT_ID)
echo "Client ID: $CLIENT_ID"
echo "Client Secret: $CLIENT_SECRET"
echo "Token URL: $TOKEN_URL"
echo "Scope: $SCOPE"

# Make the POST request to get the token
RESPONSE=$(curl -X POST $TOKEN_URL \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID" \
  -d "scope=$SCOPE" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials")

# Print the response
echo "Response: $RESPONSE"
