Sure, here's a stored procedure that encapsulates the functionality for searching the database objects for occurrences of values stored in a table:

```sql
CREATE PROCEDURE SearchForValuesInDatabaseObjects
AS
BEGIN
    -- Create a temporary table to store the values
    CREATE TABLE #SearchValues (
        ValueToSearch VARCHAR(100)
    )

    -- Insert the 100 values into the temporary table
    INSERT INTO #SearchValues (ValueToSearch)
    SELECT value_column FROM your_table

    -- Declare variables
    DECLARE @value_to_search VARCHAR(100)
    DECLARE @sql_query VARCHAR(MAX)

    -- Declare a cursor to iterate over the values
    DECLARE search_cursor CURSOR FOR
    SELECT ValueToSearch FROM #SearchValues

    -- Open the cursor
    OPEN search_cursor

    -- Fetch the first value from the cursor
    FETCH NEXT FROM search_cursor INTO @value_to_search

    -- Loop through each value
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Construct the SQL query dynamically
        SET @sql_query = 'SELECT o.name AS object_name, c.text
                          FROM sysobjects o
                          JOIN syscomments c ON o.id = c.id
                          WHERE c.text LIKE ''%' + @value_to_search + '%''
                          AND o.type IN (''P'', ''FN'', ''TF'', ''V'')'

        -- Execute the dynamic SQL query
        EXEC(@sql_query)

        -- Fetch the next value from the cursor
        FETCH NEXT FROM search_cursor INTO @value_to_search
    END

    -- Close and deallocate the cursor
    CLOSE search_cursor
    DEALLOCATE search_cursor

    -- Drop the temporary table
    DROP TABLE #SearchValues
END
```

To use this stored procedure, you would first need to replace `'your_table'` with the name of your table containing the values. Then you can simply call the stored procedure `SearchForValuesInDatabaseObjects` to execute the search.
