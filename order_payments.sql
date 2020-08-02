CREATE TABLE tblAuxOrderPayments(
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
	payment_value FLOAT
)


BULK INSERT tblAuxOrderPayments
FROM "C:\Users\h.yamamoto\Documents\Nivelamento SQL\55151_195341_bundle_archive\olist_order_payments_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
);

select top 10 * from tblOrdersDataset

CREATE TABLE tblOrderPayments(
	Id_Payment INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Id_Order INT,
    Payment_Sequential INT,
    Payment_Type VARCHAR(50),
    Payment_Installments INT,
	Payment_Value FLOAT,
	CONSTRAINT [FK_tblOrderPayments_tblOrdersDataset] FOREIGN KEY ([Id_Order]) REFERENCES [dbo].[tblOrdersDataset]([Id_Order])
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


INSERT INTO tblOrderPayments(
	Id_Order, 
	Payment_Sequential, 
	Payment_Type, 
	Payment_Installments, 
	Payment_Value)
	(
		SELECT
			(SELECT TOP 1 Id_Order FROM tblOrdersDataset od WHERE aux.order_id = od.Id_Order_2),
			aux.payment_sequential, 
			aux.payment_type,
			aux.payment_installments,
			aux.payment_value
		from tblAuxOrderPayments aux
	)

SELECT TOP 10 * from tblOrderPayments


































