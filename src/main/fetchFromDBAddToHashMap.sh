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


set termout off
set showmode off
set heading off
set echo off
set timing off
set time off
set feedback 0
set pagesize 0
set embedded ON
set verify OFF
###############

#!/bin/bash

param1_value=""
param2_value=""

# Parse command-line arguments
for arg in "$@"; do
    if [[ $arg == --param1=* ]]; then
        param1_value="${arg#*=}"
    elif [[ $arg == --param2=* ]]; then
        param2_value="${arg#*=}"
    fi
done

# Check if both parameters are provided
if [[ -z $param1_value || -z $param2_value ]]; then
    echo "Both --param1 and --param2 must be provided"
    exit 1
fi

# Use the values
echo "Param1 value: $param1_value"
echo "Param2 value: $param2_value"

# Further usage of param1_value and param2_value can be done here
bash script.sh --param1=value1 --param2=value2
bash script.sh --param1=value1 --param2=value2
#############################

#!/bin/bash

# Database connection details
username="your_username"
password="your_password"
database="your_database"

# SQL query to select one row from the database
sql_query="SELECT column1, column2, column3 FROM your_table WHERE condition = 'value';"

# Execute SQL query and store the result in a variable
result=$(echo "$sql_query" | sqlplus -S "${username}/${password}@${database}")

# Iterate over the result and store columns in variables
while IFS=' ' read -r col1 col2 col3; do
    # Print the values of the columns
    echo "Column 1: $col1"
    echo "Column 2: $col2"
    echo "Column 3: $col3"
    
    # You can store the values in variables here if needed
    # For example:
    # var1="$col1"
    # var2="$col2"
    # var3="$col3"
done <<< "$result"
##########################
#!/bin/bash

# Database connection details
username="your_username"
password="your_password"
database="your_database"

# Execute SQL query and store the result in a variable
result=$(sqlplus -S "${username}/${password}@${database}" <<EOF
SET PAGESIZE 0
SET FEEDBACK OFF
SELECT column1, column2, column3 FROM your_table WHERE condition = 'value';
EOF
)

# Iterate over the result and store columns in variables
while read -r col1 col2 col3; do
    # Store the values of the columns in variables
    var1="$col1"
    var2="$col2"
    var3="$col3"
    
    # Print the values of the columns
    echo "Column 1: $col1"
    echo "Column 2: $col2"
    echo "Column 3: $col3"
    
    # You can also print the variables if needed
    echo "Variable 1: $var1"
    echo "Variable 2: $var2"
    echo "Variable 3: $var3"
done <<< "$result"
