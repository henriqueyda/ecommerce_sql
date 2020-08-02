CREATE TABLE tblAuxOrderItems(
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
	shipping_limit_date DATETIME,
	price float,
	freight_value float
)

BULK INSERT tblAuxOrderItems
FROM "C:\55151_195341_bundle_archive\olist_order_items_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
)

CREATE TABLE tblOrderItems(
	Id_Order_Items_Dataset INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Id_Order INT 

)