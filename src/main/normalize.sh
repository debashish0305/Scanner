#!/bin/bash

normalize_json() {
    local data="$1"

    local result="["
    local first_record=true

    while IFS= read -r line; do
        local key=$(echo "$line" | cut -d':' -f1 | tr -d '",{}')
        local value=$(echo "$line" | cut -d':' -f2- | tr -d '",')

        if [ "$first_record" = true ]; then
            result+="{\"$key\":\"$value\"}"
            first_record=false
        else
            result+=",{\"$key\":\"$value\"}"
        fi
    done <<< "$(echo "$data" | tr -d ' ' | tr ',' '\n')"

    result+="]"
    echo "$result"
}

# Example JSON data
json_data='[
    {
        "id": 1,
        "name": "John",
        "age": 30,
        "address": {
            "city": "New York",
            "state": "NY"
        },
        "email": "john@example.com"
    },
    {
        "id": 2,
        "name": "Alice",
        "age": 25,
        "address": {
            "city": "San Francisco",
            "state": "CA"
        },
        "email": "alice@example.com"
    }
]'

# Normalize JSON data
normalized_json=$(normalize_json "$json_data")

# Print normalized JSON
echo "$normalized_json"
