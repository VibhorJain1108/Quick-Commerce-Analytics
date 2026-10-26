
USE QuickCommerceDB;
GO

-- Stockout rate by store.
SELECT
    s.StoreID,
    s.City,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN o.StockoutFlag = 1
        THEN 1 ELSE 0
    END) AS OrdersWithStockout,

    CAST(
        100.0 * SUM(CASE
            WHEN o.StockoutFlag = 1
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS StockoutRatePercent

FROM dbo.Orders AS o
JOIN dbo.Stores AS s
    ON o.StoreID = s.StoreID
GROUP BY
    s.StoreID,
    s.City
ORDER BY
    StockoutRatePercent DESC;
GO

-- Stockout rate by product category.
SELECT
    Category,
    COUNT(*) AS TotalOrders,

    SUM(CASE
        WHEN StockoutFlag = 1
        THEN 1 ELSE 0
    END) AS OrdersWithStockout,

    CAST(
        100.0 * SUM(CASE
            WHEN StockoutFlag = 1
            THEN 1 ELSE 0
        END) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS StockoutRatePercent

FROM dbo.Orders
GROUP BY Category
ORDER BY StockoutRatePercent DESC;
GO
