#!/bin/bash

# Define an array of JSON inputs
json_inputs=('{"name": "John", "details": {"age": 30, "city": "New York"}, "scores": [90, 85, 95]}'
             '{"name": "Alice", "details": {"age": 25, "city": "London"}, "scores": [88, 92, 95]}')

csv_file='output.csv'

# Remove content of existing CSV file
> "$csv_file"

# Python script to flatten JSON to CSV
python3 - <<END >> "$csv_file"
import json
import csv

# JSON inputs
json_inputs = $json_inputs

# Open CSV file in append mode
with open("$csv_file", 'a', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)

    # Write header
    header_written = False

    # Loop through JSON inputs
    for json_input in json_inputs:
        # Load JSON
        data = json.loads(json_input)

        # Flatten JSON
        flattened_data = {
            "name": data.get("name", ""),
            "age": data.get("details", {}).get("age", ""),
            "city": data.get("details", {}).get("city", ""),
            "scores": ",".join(map(str, data.get("scores", [])))
        }

        # Write header if not already written
        if not header_written:
            csv_writer.writerow(flattened_data.keys())
            header_written = True

        # Write flattened data
        csv_writer.writerow(flattened_data.values())
END
