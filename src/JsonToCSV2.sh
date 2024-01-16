import json
import csv

def flatten_json(data):
    flattened = {}

    def flatten_helper(item, parent_key=""):
        if isinstance(item, dict):
            for key, value in item.items():
                new_key = f"{parent_key}_{key}" if parent_key else key
                flatten_helper(value, new_key)
        else:
            flattened[parent_key] = item

    flatten_helper(data)
    return flattened

def json_to_csv(json_file, csv_file):
    with open(json_file, 'r') as f:
        data = json.load(f)

    flattened_data = [flatten_json(record) for record in data]

    with open(csv_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=flattened_data[0].keys())
        writer.writeheader()
        writer.writerows(flattened_data)

if __name__ == "__main__":
    import sys

    if len(sys.argv) != 3:
        print("Usage: python convert_json_to_csv.py input.json output.csv")
        sys.exit(1)

    json_file = sys.argv[1]
    csv_file = sys.argv[2]

    json_to_csv(json_file, 
    csv_file)

[
  {
    "id": 1,
    "name": "John Doe",
    "address": {
      "city": "New York",
      "zipcode": "10001"
    },
    "phone_numbers": {
      "home": "123-456-7890",
      "work": "987-654-3210"
    }
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "address": {
      "city": "San Francisco",
      "zipcode": "94105"
    },
    "phone_numbers": {
      "mobile": "555-123-4567",
      "work": "777-888-9999"
    }
  }
]

    
