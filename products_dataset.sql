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
    Id_Product VARCHAR(50) PRIMARY KEY,
    Product_Category_Name VARCHAR(500),
    Product_Name_Lenght INT,
    Product_Description_Lenght INT,
	Product_Photos_Qty INT,
	Product_Weight_G float,
	Product_Lenght_Cm float,
	Product_Height_Cm float,
	Product_Width_Cm float
)

INSERT INTO tblProducts(
	Id_Product,
    Product_Category_Name,
    Product_Name_Lenght,
    Product_Description_Lenght,
	Product_Photos_Qty,
	Product_Weight_G,
	Product_Lenght_Cm,
	Product_Height_Cm,
	Product_Width_Cm
	)(
	SELECT * FROM tblAuxProducts
	)

