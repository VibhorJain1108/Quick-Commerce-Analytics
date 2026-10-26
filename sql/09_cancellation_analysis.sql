
USE QuickCommerceDB;
GO

-- Overall cancellation metrics.
SELECT
    COUNT(*) AS TotalOrders,

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
        AVG(CASE
            WHEN OrderStatus = 'Cancelled'
            THEN CAST(
                OrderValueINR AS DECIMAL(10,2)
            )
        END)
        AS DECIMAL(10,2)
    ) AS AvgCancelledOrderValueINR

FROM dbo.Orders;
GO

-- Cancellation rate by store.
SELECT
    s.StoreID,
    s.City,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN o.OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

    CAST(
        100.0 * SUM(CASE
            WHEN o.OrderStatus = 'Cancelled'
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS CancellationRatePercent

FROM dbo.Orders AS o
JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
GROUP BY
    s.StoreID,
    s.City
ORDER BY
    CancellationRatePercent DESC;
GO

-- Cancellation rate by category.
SELECT
    Category,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0
    END) AS CancelledOrders,

    CAST(
        100.0 * SUM(CASE
            WHEN OrderStatus = 'Cancelled'
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS CancellationRatePercent

FROM dbo.Orders
GROUP BY Category
ORDER BY CancellationRatePercent DESC;
GO
