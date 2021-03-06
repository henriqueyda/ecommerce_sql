-- Customer table creation 
CREATE TABLE tblAuxCustomersDataset(
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(2)
)
 
BULK INSERT tblAuxCustomersDataset
FROM "C:\55151_195341_bundle_archive\olist_customers_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
)

 
CREATE TABLE tblCustomer(
	Id_Customer INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Id_Customer_2 VARCHAR(50),
    Id_Unique_Customer VARCHAR(50),
	Id_Localizacao INT,
    CONSTRAINT [FK_tblCustomer_tblLocalizacao] FOREIGN KEY ([Id_Localizacao]) REFERENCES [dbo].[tblLocalizacao]([Id_Localizacao])
)


INSERT INTO tblCustomer(Id_Customer_2, Id_Unique_Customer, Id_Localizacao)
(
	select aux.customer_id, aux.customer_unique_id, 
	(select top 1 l.Id_Localizacao from tblLocalizacao l
		where aux.customer_zip_code_prefix = l.Zip_Code_Localizacao) 
	from tblAuxCustomersDataset aux	
)