DECLARE @value_to_search VARCHAR(100)
DECLARE @sql_query VARCHAR(MAX)

DECLARE search_cursor CURSOR FOR
SELECT value_column FROM your_table

OPEN search_cursor
FETCH NEXT FROM search_cursor INTO @value_to_search

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql_query = 'SELECT o.name AS object_name, c.text
                      FROM sysobjects o
                      JOIN syscomments c ON o.id = c.id
                      WHERE c.text LIKE ''%' + @value_to_search + '%''
                      AND o.type IN (''P'', ''FN'', ''TF'', ''V'')'

    EXEC(@sql_query)

    FETCH NEXT FROM search_cursor INTO @value_to_search
END

CLOSE search_cursor
DEALLOCATE search_cursor
