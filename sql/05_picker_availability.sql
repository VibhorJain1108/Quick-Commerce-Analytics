
USE QuickCommerceDB;
GO

SELECT
    CASE
        WHEN PickerAvailable = 1
            THEN 'Picker Available'
        ELSE 'Picker Unavailable'
    END AS PickerStatus,

    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN OrderStatus = 'Delivered'
        THEN 1 ELSE 0
    END) AS DeliveredOrders,

    CAST(
        AVG(CAST(PickingMinutes AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS AvgPickingMinutes,

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
    ) AS OnTimeDeliveryPercent

FROM dbo.Orders
GROUP BY PickerAvailable
ORDER BY PickerAvailable DESC;
GO

-- Compare picker availability across all stores.
SELECT
    s.StoreID,
    s.City,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN o.PickerAvailable = 1
        THEN 1 ELSE 0
    END) AS OrdersWithPicker,

    CAST(
        100.0 * SUM(CASE
            WHEN o.PickerAvailable = 1
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS PickerAvailabilityPercent

FROM dbo.Orders AS o
JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
GROUP BY
    s.StoreID,
    s.City
ORDER BY
    PickerAvailabilityPercent ASC;
GO
