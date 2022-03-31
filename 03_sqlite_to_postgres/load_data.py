import sqlite3

from db_psycopg import pg_get_connection
from db_sqlite import sqlite_get_connection
from pg_saver import PostgresSaver
from psycopg2.extensions import connection as _connection
from sqlite_loader import SQLiteLoader

BATCH_SIZE = 500


def load_from_sqlite(connection: sqlite3.Connection, pg_connection: _connection):
    """Основной метод загрузки данных из SQLite в Postgres"""

    postgres_saver = PostgresSaver(pg_connection)
    sqlite_loader = SQLiteLoader(connection)

    tables = sqlite_loader.get_tables()
    for table in tables:
        data = sqlite_loader.load_table_gen(table, batch_size=BATCH_SIZE)
        for chunk in data:
            postgres_saver.save_all_data(chunk, table)


if __name__ == '__main__':
    dsl = {'dbname': 'movies_database', 'user': 'app', 'password': '123qwe', 'host': '127.0.0.1', 'port': 5432}
    with sqlite_get_connection('db.sqlite') as sqlite_conn, pg_get_connection(dsl) as pg_conn:
        load_from_sqlite(sqlite_conn, pg_conn)
