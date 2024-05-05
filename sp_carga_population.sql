CREATE PROCEDURE [dbo].[CARGAR_POPULATION_JSON]
@ruta VARCHAR (200)
AS
BEGIN
    DECLARE @json_data AS VARCHAR (MAX);
    DECLARE @sql_query AS NVARCHAR (MAX);
    SET @sql_query = N'SELECT @json_data = BulkColumn  
FROM OPENROWSET(
    BULK ''' + @ruta + ''', SINGLE_CLOB
) AS DATASOURCE;';
    EXECUTE sp_executesql @sql_query, N'@json_data VARCHAR(MAX) OUTPUT', @json_data OUTPUT;
    INSERT INTO population (name, code, year, value)
    SELECT "Country Name" AS "name",
           "Country Code" AS "code",
           "Year" AS "year",
           "Value" AS "value"
    FROM   OPENJSON (@json_data) WITH ("Country Name" VARCHAR (50), "Country Code" VARCHAR (50), "Year" SMALLINT, "Value" NUMERIC);
END
