
import pyodbc
from rag_pipeline import answer_from_knowledge_base


def get_connection():
    """Connect to the QuickCommerceDB SQL Server database."""
    connection_string = (
        "DRIVER={ODBC Driver 18 for SQL Server};"
        r"SERVER=localhost\SQLEXPRESS;"
        "DATABASE=QuickCommerceDB;"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )
    return pyodbc.connect(connection_string)


def choose_tool(question):
    """Route numerical questions to SQL and documentation questions to RAG."""
    question_lower = question.lower()

    sql_keywords = [
        "calculate",
        "count",
        "how many",
        "lowest rate",
        "highest rate",
        "compare cities",
        "on-time delivery rate",
        "cancellation rate",
        "total orders",
        "delivery performance",
        "which city",
        "which cities",
        "store performance",
        "average picking time",
        "cancelled",
        "canceled",
        "order status",
        "how many stores",
        "number of stores",
    ]

    if any(keyword in question_lower for keyword in sql_keywords):
        return "sql"

    return "knowledge"


def run_sql_query(question):
    """Execute only predefined, read-only SQL queries."""
    question_lower = question.lower()

    approved_queries = {
        "total_orders": (
            "SELECT COUNT(*) AS TotalOrders FROM dbo.Orders"
        ),
        "total_stores": (
            "SELECT COUNT(*) AS TotalStores FROM dbo.Stores"
        ),
        "order_status": (
            """
            SELECT OrderStatus, COUNT(*) AS OrderCount
            FROM dbo.Orders
            GROUP BY OrderStatus
            ORDER BY OrderStatus
            """
        ),
        "city_delivery": (
            """
            SELECT
                s.City,
                COUNT(*) AS DeliveredOrders,
                CAST(
                    100.0 * SUM(
                        CASE
                            WHEN o.ActualDeliveryMinutes
                                 <= o.PromisedDeliveryMinutes
                            THEN 1
                            ELSE 0
                        END
                    ) / COUNT(*) AS DECIMAL(5,2)
                ) AS OnTimeRatePercent
            FROM dbo.Orders AS o
            INNER JOIN dbo.Stores AS s
                ON o.StoreID = s.StoreID
            WHERE o.CancelledFlag = 0
            GROUP BY s.City
            ORDER BY OnTimeRatePercent ASC
            """
        ),
        "cancellation_rate": (
            """
            SELECT
                COUNT(*) AS TotalOrders,
                SUM(
                    CASE WHEN CancelledFlag = 1 THEN 1 ELSE 0 END
                ) AS CancelledOrders,
                CAST(
                    100.0 * SUM(
                        CASE WHEN CancelledFlag = 1 THEN 1 ELSE 0 END
                    ) / COUNT(*) AS DECIMAL(5,2)
                ) AS CancellationRatePercent
            FROM dbo.Orders
            """
        ),
        "average_picking_time": (
            """
            SELECT
                CAST(
                    AVG(1.0 * PickingMinutes) AS DECIMAL(6,2)
                ) AS AveragePickingMinutes
            FROM dbo.Orders
            WHERE CancelledFlag = 0
            """
        ),
    }

    # Select an approved query based on the question.
    if (
        "cancellation rate" in question_lower
        or "cancelled" in question_lower
        or "canceled" in question_lower
    ):
        query_key = "cancellation_rate"

    elif "picking time" in question_lower:
        query_key = "average_picking_time"

    elif (
        "city" in question_lower
        or "cities" in question_lower
        or "delivery rate" in question_lower
        or "delivery performance" in question_lower
        or "lowest rate" in question_lower
        or "highest rate" in question_lower
        or "compare cities" in question_lower
    ):
        query_key = "city_delivery"

    elif (
        "store" in question_lower
        and (
            "how many" in question_lower
            or "count" in question_lower
            or "number of" in question_lower
        )
    ):
        query_key = "total_stores"

    elif "status" in question_lower:
        query_key = "order_status"

    else:
        query_key = "total_orders"

    connection = None

    try:
        connection = get_connection()
        cursor = connection.cursor()

        cursor.execute(approved_queries[query_key])

        columns = [column[0] for column in cursor.description]
        rows = cursor.fetchall()

        result = [
            dict(zip(columns, row))
            for row in rows
        ]

        cursor.close()

        # Format city-level delivery results.
        if query_key == "city_delivery":
            lines = [
                "On-time delivery rates by city (lowest first):"
            ]

            for index, item in enumerate(result, start=1):
                lines.append(
                    f"{index}. {item['City']}: "
                    f"{item['OnTimeRatePercent']}% on-time "
                    f"({item['DeliveredOrders']} delivered orders)"
                )

            return "\n".join(lines)

        # Format total-order results.
        if query_key == "total_orders":
            return (
                "Total orders in the database: "
                f"{result[0]['TotalOrders']}"
            )

        # Format total-store results.
        if query_key == "total_stores":
            return (
                "Total stores in the database: "
                f"{result[0]['TotalStores']}"
            )

        # Format cancellation results.
        if query_key == "cancellation_rate":
            item = result[0]

            return (
                f"Total orders: {item['TotalOrders']}\n"
                f"Cancelled orders: {item['CancelledOrders']}\n"
                f"Cancellation rate: "
                f"{item['CancellationRatePercent']}%"
            )

        # Format average picking time.
        if query_key == "average_picking_time":
            return (
                "Average picking time among non-cancelled orders: "
                f"{result[0]['AveragePickingMinutes']} minutes"
            )

        # Format other tabular results.
        lines = []

        for item in result:
            lines.append(
                ", ".join(
                    f"{key}: {value}"
                    for key, value in item.items()
                )
            )

        return "\n".join(lines)

    except pyodbc.Error as error:
        return f"SQL database error: {error}"

    finally:
        if connection is not None:
            connection.close()


def run_agent(question):
    """Route the question to the appropriate tool."""
    tool = choose_tool(question)

    print(f"\nSelected tool: {tool}")

    if tool == "knowledge":
        return answer_from_knowledge_base(question)

    return run_sql_query(question)


if __name__ == "__main__":
    question = input(
        "Ask the QuickCommerce Analytics agent: "
    )

    answer = run_agent(question)

    print("\nAgent response:\n")
    print(answer)
