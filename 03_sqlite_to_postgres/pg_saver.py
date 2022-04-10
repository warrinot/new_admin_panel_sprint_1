from dataclasses import asdict

from db_psycopg import get_cursor
from psycopg2.extensions import connection as _connection
from psycopg2.extras import execute_values


class PostgresSaver:

    def __init__(self, connection: _connection):
        self.connection = connection

    def save_all_data(self, data, table_name: str, schema='content'):
        """Метод сохранения данных в базу postgres"""

        data = list(data)
        table_name_with_schema = f'{schema}.{table_name}'

        with get_cursor(self.connection) as cursor:
            fields = data[0].__annotations__.keys()
            fields_template = ', '.join(fields)
            fields_template = fields_template.replace('created_at', 'created')
            fields_template = fields_template.replace('updated_at', 'modified')

            data = [tuple(asdict(element).values()) for element in data]

            insert_query = '''INSERT INTO {} ({})
                              VALUES %s
                              ON CONFLICT (id) DO NOTHING;''' \
                .format(table_name_with_schema, fields_template)

            execute_values(cursor, insert_query, data)

        self.connection.commit()
