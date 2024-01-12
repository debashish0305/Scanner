#!/bin/bash

# Your shell script logic here

# Python script
python3 <<END
import csv

def flatten_json(json_data, prefix=''):
    flattened = {}
    for key, value in json_data.items():
        new_key = f"{prefix}{key}"
        if isinstance(value, dict):
            flattened.update(flatten_json(value, new_key + '_'))
        elif isinstance(value, list):
            for i, item in enumerate(value):
                if isinstance(item, dict):
                    flattened.update(flatten_json(item, f"{new_key}_{i}_"))
        else:
            flattened[new_key] = value
    return flattened

def write_csv(json_data, csv_file):
    with open(csv_file, 'w', newline='') as csvfile:
        fieldnames = flatten_json(json_data).keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerow(flatten_json(json_data))

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

write_csv(nested_json_data, 'output.csv')
END
