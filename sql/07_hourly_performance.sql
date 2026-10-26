
USE QuickCommerceDB;
GO

SELECT
    HourOfDay,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Delivered'
        THEN 1 ELSE 0
    END) AS DeliveredOrders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

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
    ) AS AvgActualDeliveryMinutes,

    CAST(
        AVG(CAST(PickingMinutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgPickingMinutes

FROM dbo.Orders
GROUP BY HourOfDay
ORDER BY HourOfDay;
GO

-- Rank the busiest hours.
SELECT
    HourOfDay,
    COUNT(*) AS TotalOrders
FROM dbo.Orders
GROUP BY HourOfDay
ORDER BY TotalOrders DESC, HourOfDay;
GO
