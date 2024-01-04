#!/bin/bash

# Set your Oracle database connection details
DB_USERNAME="your_username"
DB_PASSWORD="your_password"
DB_CONNECTION_STRING="your_connection_string"

# URL to fetch JSON data
JSON_URL="https://example.com/api/data"

# Paths for temporary files
JSON_FILE="/tmp/data.json"
CSV_FILE="/tmp/data.csv"
LOG_FILE="/tmp/audit.log"

# Audit table
AUDIT_TABLE="audit_table"

# Generate a unique load ID
LOAD_ID=$(date +"%Y%m%d%H%M%S")

# Function to log audit information
log_audit() {
    local step_description="$1"
    sqlplus -S "$DB_USERNAME/$DB_PASSWORD@$DB_CONNECTION_STRING" <<EOF
    INSERT INTO $AUDIT_TABLE (load_id, timestamp, step, status, details) VALUES ('$LOAD_ID', SYSTIMESTAMP, '$step_description', 'Success', 'Load ID: $LOAD_ID');
    COMMIT;
    EXIT;
EOF
}

# Log the start of the process
log_audit "Process started"

####################
# Step 1: Retrieve JSON data
####################
log_audit "Step 1: Retrieving JSON data from $JSON_URL"

# Using curl to fetch JSON data and save it to a file
curl -s "$JSON_URL" > "$JSON_FILE"

log_audit "Retrieved JSON data and saved to $JSON_FILE"

####################
# Step 2: Transform JSON to CSV using jq
####################
log_audit "Step 2: Transforming JSON to CSV"

# Using jq to transform JSON to CSV and save it to a file
jq -r '.[] | [.field1, .field2, .field3] | @csv' "$JSON_FILE" > "$CSV_FILE"

log_audit "Transformed JSON to CSV and saved to $CSV_FILE"

####################
# Step 3: Load CSV data into Oracle database using sqlldr
####################
log_audit "Step 3: Loading CSV data into Oracle database"

# Using sqlldr to load CSV data into the Oracle database
sqlldr "$DB_USERNAME/$DB_PASSWORD@$DB_CONNECTION_STRING" control=your_control_file.ctl data="$CSV_FILE" log="$LOG_FILE"

log_audit "Loaded CSV data into Oracle database"

####################
# Step 4: Log completion
####################
log_audit "Step 4: Process completed successfully"

# Cleanup: Remove temporary files
rm -f "$JSON_FILE" "$CSV_FILE"
