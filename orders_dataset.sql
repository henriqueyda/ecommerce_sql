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

BULK INSERT tblAuxOrdersDataset
FROM "C:\55151_195341_bundle_archive\olist_orders_dataset.csv"
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
    Order_Status INT,
    Order_Purchase_timestamp DATETIME,
	Order_Approved_at DATETIME,
	Order_Delivered_Carrier_Date DATETIME,
	Order_Delivered_Customer_Date DATETIME,
	Order_Estimated_Delivery_Date DATETIME,
	CONSTRAINT [FK_tblOrdersDataset_tblCustomer] FOREIGN KEY ([Id_Customer]) REFERENCES [dbo].[tblCustomer]([Id_Customer]),
	CONSTRAINT [FK_tblOrdersDataset_tblOrderStatus] FOREIGN KEY ([Order_Status]) REFERENCES [dbo].[tblOrderStatus]([Id_Order_Status])
)

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
			tblOrderStatus.Id_Order_Status, 
			aux.order_purchase_timestamp, 
			aux.order_approved_at, 
			aux.order_delivered_carrier_date, 
			aux.order_delivered_customer_date, 
			aux.order_estimated_delivery_date
		from tblAuxOrdersDataset aux
		LEFT JOIN tblOrderStatus ON tblOrderStatus.Order_Status = aux.order_status
	)
