CREATE TABLE tblAuxProducts(
    product_id VARCHAR(50),
    product_category_name VARCHAR(500),
    product_name_lenght INT,
    product_description_lenght INT,
	product_photos_qty INT,
	product_weight_g float,
	product_lenght_cm float,
	product_height_cm float,
	product_width_cm float
)

BULK INSERT tblAuxProducts
FROM "C:\55151_195341_bundle_archive\olist_products_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
)

CREATE TABLE tblProducts(
	Id_Product INT IDENTITY(1,1) PRIMARY KEY,
    Id_Product_2 VARCHAR(50),
    Product_Category_Name INT,
    Product_Name_Lenght INT,
    Product_Description_Lenght INT,
	Product_Photos_Qty INT,
	Product_Weight_G float,
	Product_Lenght_Cm float,
	Product_Height_Cm float,
	Product_Width_Cm float,
	CONSTRAINT [FK_tblProducts_tblProductCategory] FOREIGN KEY ([Product_Category_Name]) REFERENCES [dbo].[tblProductCategory]([Id_Product_Category])
)

INSERT INTO tblProducts(
	Id_Product_2,
    Product_Category_Name,
    Product_Name_Lenght,
    Product_Description_Lenght,
	Product_Photos_Qty,
	Product_Weight_G,
	Product_Lenght_Cm,
	Product_Height_Cm,
	Product_Width_Cm
	)(
	SELECT
		product_id,
		tblProductCategory.Id_Product_Category,
		product_name_lenght,
		product_description_lenght,
		product_photos_qty,
		product_weight_g,
		product_lenght_cm,
		product_height_cm,
		product_width_cm
	FROM tblAuxProducts
	left join tblProductCategory on tblProductCategory.Product_Category_Name = tblAuxProducts.product_category_name
	)
