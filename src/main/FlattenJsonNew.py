import json
import csv

# Function to flatten nested JSON
def flatten_json(json_obj, prefix='', separator='|'):
    items = {}
    for key, value in json_obj.items():
        new_key = prefix + separator + key if prefix else key
        if isinstance(value, dict):
            items.update(flatten_json(value, new_key, separator))
        elif isinstance(value, list):
            for idx, item in enumerate(value):
                items.update(flatten_json(item, f"{new_key}[{idx}]", separator))
        else:
            items[new_key] = value
    return items

# JSON data
data = {
    "d": {
        "results": [
            {
                "meta": {
                    "id": "1",
                    "url": "rrr"
                },
                "city": "Mumbai",
                "state": "Maha"
            },
            {
                "meta": {
                    "id": "2",
                    "url": "wwrr"
                },
                "city": "Banglore",
                "state": "KN"
            }
        ]
    }
}

# Flatten JSON
flat_data_list = [flatten_json(result) for result in data["d"]["results"]]

# Custom header
custom_header = ["ID", "URL", "City", "State"]

# Write flattened data to CSV with custom header
with open('output.csv', 'w', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=custom_header)
    writer.writeheader()
    writer.writerows(flat_data_list)
