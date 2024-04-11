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
############################
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

echo "SQL Query: $query"

# Connect to the database and execute the query
output=$(sqlplus -S "$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_HOST)(PORT=1521))(CONNECT_DATA=(SID=$DB_NAME)))" <<EOF
set pagesize 0
set feedback off
set verify off
set heading off
set echo off
$query
EOF
)

echo "Output from SQL*Plus:"
echo "$output"
##################################################
#!/bin/bash

# Database connection details
DB_USER="your_db_username"
DB_PASS="your_db_password"
DB_NAME="your_db_name"
DB_HOST="your_db_host"

# Input parameters
ENV="$1"
KEY1="$2"
KEY2="$3"

# Declare an associative array to store key-value pairs
declare -A hashmap

# SQL query to fetch data
query="SELECT VALUE, PARAM1, PARAM2, PARAM3, PARAM4, PARAM5 FROM your_table WHERE ENV='$ENV' AND KEY1='$KEY1' AND KEY2='$KEY2';"

# Connect to the database and execute the query
output=$(sqlplus -S "$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_HOST)(PORT=1521))(CONNECT_DATA=(SID=$DB_NAME)))" <<EOF
set pagesize 0
set feedback off
set verify off
set heading off
set echo off
$query
EOF
)

# Check if output is empty
if [ -z "$output" ]; then
    echo "No data found for ENV='$ENV', KEY1='$KEY1', KEY2='$KEY2'"
    exit 1
fi

# Process the output and create key-value pairs
while IFS=" " read -r value param1 param2 param3 param4 param5; do
    # Concatenate the parameters
    concatenated_params="${param1}${param2}${param3}${param4}${param5}"
    # Create the key-value pair
    key="${ENV}${KEY1}${KEY2}"
    value="${value},${concatenated_params}"
    # Store the key-value pair in the hashmap
    hashmap["$key"]=$value
done <<< "$output"

# Print the hashmap
for key in "${!hashmap[@]}"; do
    echo "Key: $key, Value: ${hashmap[$key]}"
done
#####################

#!/bin/bash

# Database connection details
DB_USER="your_db_username"
DB_PASS="your_db_password"
DB_NAME="your_db_name"
DB_HOST="your_db_host"

# Input parameters
ENV="$1"
KEY1="$2"
KEY2="$3"

# SQL query to fetch data
query="SELECT VALUE, PARAM1, PARAM2, PARAM3, PARAM4, PARAM5 FROM your_table WHERE ENV='$ENV' AND KEY1='$KEY1' AND KEY2='$KEY2';"

# Connect to the database and execute the query
output=$(sqlplus -S "$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$DB_HOST)(PORT=1521))(CONNECT_DATA=(SID=$DB_NAME)))" <<EOF
set pagesize 0
set feedback off
set verify off
set heading off
set echo off
$query
EOF
)

# Check if output is empty
if [ -z "$output" ]; then
    echo "No data found for ENV='$ENV', KEY1='$KEY1', KEY2='$KEY2'"
    exit 1
fi

# Process the output row-wise
while IFS= read -r row; do
    # Split the row into individual fields
    IFS=' ' read -r -a fields <<< "$row"
    
    # Extract individual values from the fields
    value="${fields[0]}"
    param1="${fields[1]}"
    param2="${fields[2]}"
    param3="${fields[3]}"
    param4="${fields[4]}"
    param5="${fields[5]}"

    # Concatenate the parameters
    concatenated_params="${param1}${param2}${param3}${param4}${param5}"

    # Create the key-value pair
    key="${ENV}${KEY1}${KEY2}"
    value="${value},${concatenated_params}"
    
    # Print the key-value pair
    echo "Key: $key, Value: $value"
done <<< "$output"
