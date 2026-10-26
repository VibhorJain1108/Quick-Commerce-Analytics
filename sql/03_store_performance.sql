
USE QuickCommerceDB;
GO

SELECT
    s.StoreID,
    s.StoreName,
    s.City,
    COUNT(o.OrderID) AS TotalOrders,

    SUM(CASE
        WHEN o.OrderStatus = 'Delivered'
        THEN 1 ELSE 0
    END) AS DeliveredOrders,

    SUM(CASE
        WHEN o.OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

    CAST(
        100.0 * SUM(CASE
            WHEN o.OrderStatus = 'Delivered'
            THEN 1 ELSE 0
        END) / NULLIF(COUNT(o.OrderID), 0)
        AS DECIMAL(5,2)
    ) AS FulfillmentRatePercent,

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
    ) AS OnTimeDeliveryPercent,

    CAST(
        AVG(CAST(o.PickingMinutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgPickingMinutes

FROM dbo.Stores AS s
LEFT JOIN dbo.Orders AS o
    ON s.StoreID = o.StoreID
GROUP BY
    s.StoreID,
    s.StoreName,
    s.City
ORDER BY
    OnTimeDeliveryPercent ASC;
GO
