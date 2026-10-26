
USE QuickCommerceDB;
GO

-- Create the Stores master table if it does not exist.
IF OBJECT_ID('dbo.Stores', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Stores (
        StoreID VARCHAR(10) PRIMARY KEY,
        StoreName VARCHAR(100) NOT NULL,
        City VARCHAR(50) NOT NULL,
        StaffCapacity INT NOT NULL
    );
END;
GO

-- Create the Orders transaction table if it does not exist.
IF OBJECT_ID('dbo.Orders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders (
        OrderID VARCHAR(15) PRIMARY KEY,
        StoreID VARCHAR(10) NOT NULL,
        OrderTimestamp DATETIME2 NOT NULL,
        HourOfDay INT NOT NULL,
        Category VARCHAR(50) NOT NULL,
        ItemsCount INT NOT NULL,
        OrderValueINR DECIMAL(10,2) NOT NULL,
        PromisedDeliveryMinutes INT NOT NULL,
        PickingMinutes INT NOT NULL,
        PickerAvailable BIT NOT NULL,
        StockoutFlag BIT NOT NULL,
        CancelledFlag BIT NOT NULL,
        ActualDeliveryMinutes INT NULL,
        OrderStatus VARCHAR(20) NOT NULL,

        CONSTRAINT FK_Orders_Stores
            FOREIGN KEY (StoreID)
            REFERENCES dbo.Stores(StoreID)
    );
END;
GO

-- Confirm that both tables exist.
SELECT
    OBJECT_SCHEMA_NAME(object_id) AS SchemaName,
    name AS TableName
FROM sys.tables
WHERE name IN ('Stores', 'Orders');
GO
