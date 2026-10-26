
USE QuickCommerceDB;
GO

SELECT
    COUNT(*) AS TotalOrders,

    COUNT(DISTINCT StoreID) AS TotalStores,

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
            WHEN OrderStatus = 'Cancelled'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(5,2)
    ) AS CancellationRatePercent,

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
        AVG(CAST(OrderValueINR AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgOrderValueINR,

    CAST(
        AVG(CAST(PickingMinutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgPickingMinutes

FROM dbo.Orders;
GO

-- Store with the lowest on-time delivery rate.
SELECT TOP 1
    s.StoreID,
    s.City,

    CAST(
        100.0 * SUM(CASE
            WHEN o.OrderStatus = 'Delivered'
             AND o.ActualDeliveryMinutes
                 <= o.PromisedDeliveryMinutes
            THEN 1 ELSE 0
        END)
        / NULLIF(SUM(CASE
            WHEN o.OrderStatus = 'Delivered'
            THEN 1 ELSE 0
        END), 0)
        AS DECIMAL(5,2)
    ) AS OnTimeDeliveryPercent

FROM dbo.Orders AS o
JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
GROUP BY
    s.StoreID,
    s.City
HAVING SUM(CASE
    WHEN o.OrderStatus = 'Delivered'
    THEN 1 ELSE 0
END) > 0
ORDER BY OnTimeDeliveryPercent ASC;
GO
