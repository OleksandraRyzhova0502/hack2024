import json
import pandas as pd
import psycopg2
from psycopg2 import Error
from sqlalchemy import create_engine


with open('/Users/aleksandraryzhova/Downloads/credentials.json') as json_file:
    credentials = json.load(json_file)

dbname = credentials['dbname']
user = credentials['user']
password = credentials['password']
host = credentials['host']
port = credentials['port']

connection_str = f'postgresql://{user}:{password}@{host}:{port}/{dbname}'


dct_csv = {'orders_csv': '/Users/aleksandraryzhova/Downloads/(2)/pizza_sales/order_details.csv',
           'order_details_csv': '/Users/aleksandraryzhova/Downloads/(2)/pizza_sales/order_details.csv',
           'pizza_types_csv': '/Users/aleksandraryzhova/Downloads/(2)/pizza_sales/pizza_types.csv',
           'pizzas_csv': '/Users/aleksandraryzhova/Downloads/(2)/pizza_sales/pizzas.csv'}


# Function to load CSV data into a PostgreSQL table
def load_csv_to_postgres(csv_file, table_name, engine):
    try:
        df = pd.read_csv(csv_file)
        df.to_sql(table_name, engine)
        print(f"CSV data successfully loaded into the '{table_name}' table")
    except Error as e:
        print(f"The error '{e}' occurred")


def main():
    # create connection
    engine = create_engine(connection_str)
    for key in dct_csv.keys():
        csv_file = dct_csv[key]
        table_name = key
        load_csv_to_postgres(csv_file, table_name, engine)
        print(f'Load csv {csv_file} was successful')

main()
