# Parallel Queries Runner

This script is designed to execute parallel queries on a PostgreSQL database, using multiprocessing for improved performance. 
It is particularly useful for analyzing or vacuuming multiple tables concurrently.

## Features

- **Parallel Execution**: The script utilizes the `multiprocessing` module to run queries concurrently, enhancing the overall efficiency.
- **Logging**: Logging is implemented to keep track of the script's progress. Information is logged to both a file (`logfilename.log`) and the console.
- **Connection Pool**: The script employs a connection pool to manage database connections effectively, with the number of connections defined by `CONNECTION_NUMBER`.


## Setup

Configure the script parameters by following these steps:

### Database Connection

Customize the PostgreSQL database connection parameters in the script:

```python
database_port = 5432
database_user = "postgres"
database_host = "localhost"
database_name = "my_database_name"
database_password = "my_database_password"
```

Ensure that the provided information aligns with your PostgreSQL database.

### Query Template

Tailor the query template to your needs. Note: Retain the `{table}` placeholder for dynamic table name substitution during execution.

Default query template:

```python
QUERY_TEMPLATE = "VACUUM FULL ANALYZE {table}"
```

### Tables

Specify tables for the script to process by updating the `TABLES` list. Include schema and table names in the format "schema.table":

```python
TABLES = [
    "schema1.table1",
    "schema1.table2",
    "schema2.table1"
]
```

Now you are ready to run the script with the configured parameters.

## Usage

1. Ensure that PostgreSQL is running and reachable with the provided connection details.
2. Run the script:

    ```bash
    python script_name.py
    ```

3. Monitor the logs for progress updates. The script will execute the specified queries in parallel.

## Dependencies

- [pg8000](https://github.com/mfenniak/pg8000): A PostgreSQL adapter for Python.


## License

This script is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
