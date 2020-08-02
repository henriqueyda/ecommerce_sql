CREATE TABLE tblAuxOrdersDataset(
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
	order_approved_at DATETIME,
	order_delivered_carrier_date DATETIME,
	order_delivered_customer_date DATETIME,
	order_estimated_delivery_date DATETIME
)


CREATE VIEW tblAuxOrdersDataset_VIEWAUX
AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date
FROM tblAuxOrdersDataset

BULK INSERT tblAuxOrdersDataset
FROM "C:\Users\h.yamamoto\Documents\Nivelamento SQL\55151_195341_bundle_archive\olist_orders_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
);

CREATE TABLE tblOrdersDataset(
	Id_Order INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Id_Order_2 VARCHAR(50),
    Id_Customer INT NOT NULL,
    Order_Status VARCHAR(50),
    Order_Purchase_timestamp DATETIME,
	Order_Approved_at DATETIME,
	Order_Delivered_Carrier_Date DATETIME,
	Order_Delivered_Customer_Date DATETIME,
	Order_Estimated_Delivery_Date DATETIME,
	CONSTRAINT [FK_tblOrdersDataset_tblCustomer] FOREIGN KEY ([Id_Customer]) REFERENCES [dbo].[tblCustomer]([Id_Customer])
)

		select
			aux.order_id,
			(select top 1 Id_Customer_2 from tblCustomer c where aux.customer_id = c.Id_Customer_2) as Id_Customer,
			aux.order_status, 
			aux.order_purchase_timestamp, 
			aux.order_approved_at, 
			aux.order_delivered_carrier_date, 
			aux.order_delivered_customer_date, 
			aux.order_estimated_delivery_date
		from tblAuxOrdersDataset aux


INSERT INTO tblOrdersDataset(
	Id_Order_2, 
	Id_Customer, 
	Order_Status, 
	Order_Purchase_timestamp, 
	Order_Approved_at, 
	Order_Delivered_Carrier_Date, 
	Order_Delivered_Customer_Date, 
	Order_Estimated_Delivery_Date)
	(
		select
			aux.order_id,
			(select top 1 Id_Customer from tblCustomer c where aux.customer_id = c.Id_Customer_2),
			aux.order_status, 
			aux.order_purchase_timestamp, 
			aux.order_approved_at, 
			aux.order_delivered_carrier_date, 
			aux.order_delivered_customer_date, 
			aux.order_estimated_delivery_date
		from tblAuxOrdersDataset aux
	)


truncate table tblOrdersDataset


select top 10 * from tblAuxOrdersDataset
select top 10 * from tblOrdersDataset

