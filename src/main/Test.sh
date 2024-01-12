#!/bin/bash

json_input='{"people": [{"name": "John", "age": 30}, {"name": "Alice", "age": 25}], "city": "New York"}'
array_node='people'
csv_file='output.csv'

# Remove content of existing CSV file
> "$csv_file"

# Python script to flatten JSON array to CSV
python3 - <<END >> "$csv_file"
import json
import csv

# JSON input
json_input = '$json_input'
array_node = '$array_node'

# Load JSON
data = json.loads(json_input)

# Get the array node
json_array = data.get(array_node, [])

# Open CSV file in append mode
with open("$csv_file", 'a', newline='') as csvfile:
    csv_writer = csv.writer(csvfile)

    # Write header
    header_written = False

    # Loop through array elements
    for entry in json_array:
        # Flatten JSON entry
        flattened_data = {key: entry[key] for key in entry.keys()}

        # Write header if not already written
        if not header_written:
            csv_writer.writerow(flattened_data.keys())
            header_written = True

        # Write flattened data
        csv_writer.writerow(flattened_data.values())
END
