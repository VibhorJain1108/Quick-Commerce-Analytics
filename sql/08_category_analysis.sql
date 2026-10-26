
USE QuickCommerceDB;
GO

SELECT
    Category,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Delivered'
        THEN 1 ELSE 0
    END) AS DeliveredOrders,

    CAST(
        AVG(CAST(OrderValueINR AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgOrderValueINR,

    CAST(
        AVG(CAST(ItemsCount AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgItemsPerOrder,

    CAST(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Delivered'
             AND ActualDeliveryMinutes
                 <= PromisedDeliveryMinutes
            THEN 1 ELSE 0
        END)
        / NULLIF(SUM(CASE
            WHEN OrderStatus = 'Delivered'
            THEN 1 ELSE 0
        END), 0)
        AS DECIMAL(5,2)
    ) AS OnTimeDeliveryPercent,

    CAST(
        AVG(CASE
            WHEN OrderStatus = 'Delivered'
            THEN CAST(
                ActualDeliveryMinutes
                AS DECIMAL(10,2)
            )
        END)
        AS DECIMAL(10,2)
    ) AS AvgDeliveryMinutes

FROM dbo.Orders
GROUP BY Category
ORDER BY TotalOrders DESC;
GO
