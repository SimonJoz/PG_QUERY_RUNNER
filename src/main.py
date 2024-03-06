# -------------------------------------------------------------
# Script for parallel queries execution in PostgreSQL database
# -------------------------------------------------------------
import logging
import multiprocessing
from typing import List

import pg8000

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Create a FileHandler and set its level to INFO
file_handler = logging.FileHandler(f'logfilename.log')
file_handler.setLevel(logging.INFO)

stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.INFO)

formatter = logging.Formatter('%(message)s')
file_handler.setFormatter(formatter)
stream_handler.setFormatter(formatter)

logger.addHandler(file_handler)
logger.addHandler(stream_handler)

database_port = 5432
database_user = "postgres"
database_host = "localhost"
database_name = "my_database_name"
database_password = "my_database_password"

# Connection pool
CONNECTION_NUMBER = 16

TABLES = [
    "schema1.table1",
    "schema1.table2",
    "schema2.table1"
]

QUERY_TEMPLATE = "VACUUM FULL ANALYZE {table}"

def main():
    logger.info("Query executor has been started.")
    execute()
    logger.info("Query executor has been completed.")


def execute():
    queries: List[str] = []

    for table in TABLES:
        queries.append(QUERY_TEMPLATE.format(table=table))

    parallel_queries(queries)


def parallel_queries(queries: List[str]):
    logger.info(f"Running {len(queries)} parallel queries")

    with multiprocessing.Pool(CONNECTION_NUMBER) as pool:
        pool.map(execute_query, queries)

    logger.info(f"Parallel queries completed.")


def execute_query(query: str):
    logger.info(f"Running query: {query}")
    connection = pg8000.connect(
        host=database_host,
        port=database_port,
        database=database_name,
        user=database_user,
        password=database_password
    )

    connection.autocommit = True
    try:
        cursor = connection.cursor()
        cursor.execute(query)
        logger.info(f"Query completed: {query}")
    finally:
        connection.close()


if __name__ == '__main__':
    main()
