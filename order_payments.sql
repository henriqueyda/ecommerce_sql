CREATE TABLE tblAuxOrderPayments(
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
	payment_value FLOAT
)


BULK INSERT tblAuxOrderPayments
FROM "C:\55151_195341_bundle_archive\olist_order_payments_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
);

CREATE TABLE tblOrderPayments(
	Id_Payment INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Id_Order INT,
    Payment_Sequential INT,
    Payment_Type INT,
    Payment_Installments INT,
	Payment_Value FLOAT,
	CONSTRAINT [FK_tblOrderPayments_tblOrdersDataset] FOREIGN KEY ([Id_Order]) REFERENCES [dbo].[tblOrdersDataset]([Id_Order]),
	CONSTRAINT [FK_tblOrderPayments_tblPaymentType] FOREIGN KEY ([Payment_Type]) REFERENCES [dbo].[tblPaymentType]([Id_Payment_Type])
)

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
			tblPaymentType.Id_Payment_Type,
			aux.payment_installments,
			aux.payment_value
		from tblAuxOrderPayments aux
		INNER JOIN tblPaymentType ON tblPaymentType.Payment_Type = aux.payment_type
	)