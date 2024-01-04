#!/bin/bash

# JSON input file
JSON_FILE="input.json"

# Log file for audit
LOG_FILE="audit.log"

# Function to log audit information
log_audit() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Python script to flatten JSON to CSV
PYTHON_SCRIPT=$(cat <<EOF
import json
import csv
from flatten_json import flatten

try:
    # Read JSON from stdin
    json_data = json.load(open("$JSON_FILE"))

    # Flatten the JSON
    flattened_data = [flatten(record) for record in json_data]

    # Write flattened data to CSV
    csv_file = "output.csv"
    with open(csv_file, "w", newline="") as csvfile:
        fieldnames = set([key for record in flattened_data for key in record.keys()])
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        # Write CSV header
        writer.writeheader()

        # Write flattened records to CSV
        for record in flattened_data:
            writer.writerow(record)

    print("Flattened JSON to CSV and saved to output.csv")

except Exception as e:
    print(f"Error: {str(e)}")
    exit(1)
EOF
)

# Run the Python script and redirect output to log file
echo "$PYTHON_SCRIPT" | python3 >> "$LOG_FILE" 2>&1

# Check if the Python script had an error
if [ $? -ne 0 ]; then
    log_audit "Error occurred during script execution. Check $LOG_FILE for details."
else
    log_audit "Script executed successfully. Check $LOG_FILE for details."
fi
