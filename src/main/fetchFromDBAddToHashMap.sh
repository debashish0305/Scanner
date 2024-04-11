#!/bin/bash

# Database connection details
DB_USER="your_db_username"
DB_PASS="your_db_password"
DB_NAME="your_db_name"
DB_HOST="your_db_host"

# Input parameters (three columns)
COLUMN1="$1"
COLUMN2="$2"
COLUMN3="$3"

# Declare an associative array to store key-value pairs
declare -A hashmap

# SQL query to fetch data
query="SELECT column1, column2, column3, column4, column5, column6, column7 FROM your_table WHERE column1='$COLUMN1' AND column2='$COLUMN2' AND column3='$COLUMN3';"

# Connect to the database and execute the query
sqlplus -S "$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_HOST)(PORT=1521))(CONNECT_DATA=(SID=$DB_NAME)))" <<EOF | while IFS=$'\t' read -r col1 col2 col3 col4 col5 col6 col7; do
$query;
EOF
    # Concatenate the other five columns
    concatenated=""
    for col in "$col4" "$col5" "$col6" "$col7"; do
        if [ -n "$col" ]; then
            concatenated+="$col "
        fi
    done

    # Store the key-value pair in the hashmap
    hashmap["$COLUMN1 $COLUMN2 $COLUMN3"]=$concatenated
done

# Print the hashmap
for key in "${!hashmap[@]}"; do
    echo "$key -> ${hashmap[$key]}"
done
###################
#!/bin/bash

# Database connection details
DB_USER="your_db_username"
DB_PASS="your_db_password"
DB_NAME="your_db_name"
DB_HOST="your_db_host"

# Input parameters (three columns)
COLUMN1="$1"
COLUMN2="$2"
COLUMN3="$3"

# SQL query to fetch data
query="SELECT column1, column2, column3, column4, column5, column6, column7 FROM your_table WHERE column1='$COLUMN1' AND column2='$COLUMN2' AND column3='$COLUMN3';"

# Connect to the database and execute the query
output=$(sqlplus -S "$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_HOST)(PORT=1521))(CONNECT_DATA=(SID=$DB_NAME)))" <<EOF
$query
EOF
)

# Check if output is empty
if [ -z "$output" ]; then
    echo "No output from SQL query."
    exit 1
fi

# Process the output
echo "$output" | while IFS=$'\t' read -r col1 col2 col3 col4 col5 col6 col7; do
    # Print each row
    echo "Row: $col1, $col2, $col3, $col4, $col5, $col6, $col7"
done
