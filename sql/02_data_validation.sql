
USE QuickCommerceDB;
GO

-- 1. Count stores and orders.
SELECT COUNT(*) AS TotalStores
FROM dbo.Stores;

SELECT COUNT(*) AS TotalOrders
FROM dbo.Orders;

-- 2. Check the order status distribution.
SELECT
    OrderStatus,
    COUNT(*) AS OrderCount
FROM dbo.Orders
GROUP BY OrderStatus
ORDER BY OrderCount DESC;

-- 3. Check for duplicate order IDs.
SELECT
    OrderID,
    COUNT(*) AS DuplicateCount
FROM dbo.Orders
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- 4. Find orders without a matching store.
SELECT o.*
FROM dbo.Orders AS o
LEFT JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
WHERE s.StoreID IS NULL;

-- 5. Check for invalid delivery times.
SELECT *
FROM dbo.Orders
WHERE PromisedDeliveryMinutes <= 0
   OR PickingMinutes < 0
   OR ActualDeliveryMinutes < 0;

-- 6. Check whether flags match the order status.
SELECT *
FROM dbo.Orders
WHERE
    (OrderStatus = 'Cancelled' AND CancelledFlag <> 1)
    OR
    (OrderStatus = 'Delivered' AND CancelledFlag <> 0);

-- 7. Verify the number of delivered and cancelled orders.
SELECT
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN OrderStatus = 'Delivered'
        THEN 1 ELSE 0 END) AS DeliveredOrders,
    SUM(CASE WHEN OrderStatus = 'Cancelled'
        THEN 1 ELSE 0 END) AS CancelledOrders
FROM dbo.Orders;
GO
