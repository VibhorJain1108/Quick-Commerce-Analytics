
USE QuickCommerceDB;
GO

SELECT
    s.StoreID,
    s.City,

    COUNT(*) AS DeliveredOrders,

    SUM(CASE
        WHEN o.ActualDeliveryMinutes
             > o.PromisedDeliveryMinutes
        THEN 1 ELSE 0
    END) AS LateOrders,

    CAST(
        100.0 * SUM(CASE
            WHEN o.ActualDeliveryMinutes
                 > o.PromisedDeliveryMinutes
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS LateDeliveryPercent,

    CAST(
        AVG(CASE
            WHEN o.ActualDeliveryMinutes
                 > o.PromisedDeliveryMinutes
            THEN CAST(
                o.ActualDeliveryMinutes
                - o.PromisedDeliveryMinutes
                AS DECIMAL(10,2)
            )
        END)
        AS DECIMAL(10,2)
    ) AS AvgDelayMinutesWhenLate,

    CAST(
        AVG(CAST(
            o.ActualDeliveryMinutes
            AS DECIMAL(10,2)
        ))
        AS DECIMAL(10,2)
    ) AS AvgActualDeliveryMinutes

FROM dbo.Orders AS o
JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
WHERE o.OrderStatus = 'Delivered'
GROUP BY
    s.StoreID,
    s.City
ORDER BY
    LateDeliveryPercent DESC;
GO
