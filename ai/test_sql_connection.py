
import pyodbc

connection_string = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    r"SERVER=localhost\SQLEXPRESS;"
    "DATABASE=QuickCommerceDB;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

try:
    connection = pyodbc.connect(connection_string)
    print("SQL Server connection successful!")

    cursor = connection.cursor()

    cursor.execute("SELECT COUNT(*) FROM dbo.Stores")
    store_count = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM dbo.Orders")
    order_count = cursor.fetchone()[0]

    print(f"Stores in database: {store_count}")
    print(f"Orders in database: {order_count}")

    cursor.close()
    connection.close()

except pyodbc.Error as error:
    print("Database connection failed:")
    print(error)
