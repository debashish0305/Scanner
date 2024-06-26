import csv
import json


def flatten_json(json_obj, parent_key='', sep='_'):
    """
    Flatten nested JSON object to a flat dictionary.
    """
    items = {}
    for k, v in json_obj.items():
        new_key = parent_key + sep + k if parent_key else k
        if isinstance(v, dict):
            items.update(flatten_json(v, new_key, sep=sep))
        else:
            items[new_key] = v
    return items


def json_to_csv(json_data, output_file):
    """
    Convert JSON data to CSV format.
    """
    flat_data = []
    if isinstance(json_data, list):
        for record in json_data:
            flat_record = flatten_json(record)
            flat_data.append(flat_record)
    elif isinstance(json_data, dict):
        flat_record = flatten_json(json_data)
        flat_data.append(flat_record)
    else:
        raise ValueError("Input data must be a JSON object or a list of JSON objects.")

    # Get field names from flattened data
    fieldnames = set()
    for record in flat_data:
        fieldnames.update(record.keys())

    # Write data to CSV
    with open(output_file, 'w') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=sorted(fieldnames))
        writer.writeheader()
        for record in flat_data:
            writer.writerow(record)


# Example usage:
json_response = [
    {
        "id": 1,
        "name": "John",
        "details": {
            "age": 30,
            "city": "New York"
        }
    },
    {
        "id": 2,
        "name": "Alice",
        "details": {
            "age": 25,
            "city": "Los Angeles"
        }
    }
]

output_csv_file = "output.csv"
json_to_csv(json_response, output_csv_file)
print("JSON response converted to CSV:", output_csv_file)
