CREATE TABLE tblAuxSellers(
	seller_id VARCHAR(50),
	seller_zip_code_prefix NVARCHAR(8),
	seller_city NVARCHAR(100),
	seller_state NVARCHAR(2)
)

BULK INSERT tblAuxSellers
FROM "C:\55151_195341_bundle_archive\olist_sellers_dataset.csv"
WITH(
	FORMAT = 'CSV',
	FIRSTROW = 2,
	CODEPAGE = '65001',
	FIELDTERMINATOR = ',',
	ROWTERMINATOR='0x0a',
	BATCHSIZE=250000,
	TABLOCK
)

CREATE TABLE tblSellers(
	Id_Seller VARCHAR(50) PRIMARY KEY,
	Seller_Localizacao INT,
	CONSTRAINT [FK_tblSellers_tblLocalizacao] FOREIGN KEY([Seller_Localizacao]) REFERENCES [tblLocalizacao]([Id_Localizacao])
)

SELECT * from tblLocalizacao
SELECT * from tblAuxSellers

INSERT INTO tblSellers(
	Id_Seller,
	Seller_Localizacao
)(
SELECT seller_id,
	(SELECT TOP 1 Id_Localizacao FROM tblLocalizacao l
	WHERE l.Zip_Code_Localizacao = aux.seller_zip_code_prefix)
FROM tblAuxSellers aux)
