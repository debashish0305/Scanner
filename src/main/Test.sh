#!/bin/bash

# Your shell script logic here

# Python script
python3 <<END
import csv

def flatten_json(json_data):
    flattened = {}
    for key, value in json_data.items():
        if isinstance(value, dict):
            flattened.update(flatten_json(value))
        elif isinstance(value, list):
            for i, item in enumerate(value):
                if isinstance(item, dict):
                    flattened.update(flatten_json(item))
        else:
            flattened[key] = value
    return flattened

def write_csv(json_data, csv_file, selected_headers):
    with open(csv_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=selected_headers)
        writer.writeheader()
        flattened_data = flatten_json(json_data)
        row = {header: flattened_data.get(header, '') for header in selected_headers}
        writer.writerow(row)

# Example usage:
nested_json_data = {
    "name": "John",
    "info": [
        {"age": 25, "address": {"city": "New York", "zipcode": "10001"}},
        {"age": 30, "address": {"city": "San Francisco", "zipcode": "94105"}}
    ],
    "skills": ["Python", "JavaScript"],
    "hobbies": ["Reading", "Traveling"]
}

# Specify the headers you want to include in the CSV
selected_headers = ["age", "zipcode"]

write_csv(nested_json_data, 'output.csv', selected_headers)
END
