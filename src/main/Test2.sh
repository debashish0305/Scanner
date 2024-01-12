#!/bin/bash

json_input='{"name": "John", "details": {"age": 30, "city": "New York"}, "scores": [90, 85, 95]}'

# Python script to flatten JSON to CSV
python3 - <<END
import json
import csv

# JSON input
json_input = '$json_input'

# Load JSON
data = json.loads(json_input)

# Flatten JSON
flattened_data = {
    "name": data.get("name", ""),
    "age": data.get("details", {}).get("age", ""),
    "city": data.get("details", {}).get("city", ""),
    "scores": ",".join(map(str, data.get("scores", [])))
}

# Convert to CSV
csv_output = ",".join(flattened_data.values())

# Print CSV result
print(csv_output)
END
