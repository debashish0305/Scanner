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

    
    "info": {
        "age": 25,
        "address": {
            "city": "New York",
            "zipcode": "10001"
        }
    },
    "skills": ["Python", "JavaScript"]
}

write_csv(nested_json_data, 'output.csv')
END




#!/bin/bash

# Your shell script logic here

# Python script
python3 <<END
import csv

def flatten_json(json_data, prefix='', selected_nodes=None):
    flattened = {}
    for key, value in json_data.items():
        new_key = f"{prefix}{key}"
        if isinstance(value, dict):
            flattened.update(flatten_json(value, new_key + '_', selected_nodes))
        elif selected_nodes is None or new_key in selected_nodes:
            flattened[new_key] = value
    return flattened

def write_csv(json_data, csv_file, selected_nodes=None):
    with open(csv_file, 'w', newline='') as csvfile:
        fieldnames = flatten_json(json_data, selected_nodes=selected_nodes).keys()
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerow(flatten_json(json_data, selected_nodes=selected_nodes))

# Example usage:
nested_json_data = {
    "name": "John",
    "info": {
        "age": 25,
        "address": {
            "city": "New York",
            "zipcode": "10001"
        }
    },
    "skills": ["Python", "JavaScript"]
}

# Specify the nodes you want to include in the CSV
selected_nodes = ["name", "info_age", "info_address_city"]

write_csv(nested_json_data, 'output.csv', selected_nodes)
END



