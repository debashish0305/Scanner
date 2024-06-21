#!/bin/bash

# Variables
username="your_username"
password="your_password"
client_id="your_client_id"
scope="your_scope"
authority="https://login.microsoftonline.com/your_tenant_id"

# Endpoint
token_endpoint="$authority/oauth2/v2.0/token"

# Request body
request_body="grant_type=password&client_id=$client_id&scope=$scope&username=$username&password=$password"

# Fetching the token
response=$(curl -s -X POST -d "$request_body" -H "Content-Type: application/x-www-form-urlencoded" "$token_endpoint")

# Parsing the token from the response
access_token=$(echo $response | grep -o '"access_token":"[^"]*' | grep -o '[^"]*$')

# Display the token
if [ -n "$access_token" ]; then
    echo "Bearer token: $access_token"
else
    echo "Failed to fetch the bearer token. Response: $response"
fi
