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
	Id_Order_Item INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Id_Order_Item_2 INT,
	Id_Order INT,
	Id_Product INT,
	Id_Seller INT,
	Shipping_Limit_Date DATETIME,
	Price FLOAT,
	Freight_Value FLOAT,
	CONSTRAINT [FK_tblOrderItems_tblOrdersDataset] FOREIGN KEY([Id_Order]) REFERENCES [tblOrdersDataset]([Id_Order]),
	CONSTRAINT [FK_tblOrderItems_tblProducts] FOREIGN KEY([Id_Product]) REFERENCES [tblProducts]([Id_Product]),
	CONSTRAINT [FK_tblOrderItems_tblSellers] FOREIGN KEY([Id_Seller]) REFERENCES [tblSellers]([Id_Seller])
	)

INSERT INTO tblOrderItems(
	Id_Order_Item_2,
	Id_Order,
	Id_Product,
	Id_Seller,
	Shipping_Limit_Date,
	Price,
	Freight_Value 
)(
SELECT 
	order_item_id,	
	tblOrdersDataset.Id_Order,
	tblProducts.Id_Product,
	tblSellers.Id_Seller,
	shipping_limit_date,
	price,
	freight_value
FROM tblAuxOrderItems
left join tblOrdersDataset ON tblOrdersDataset.Id_Order_2 = tblAuxOrderItems.order_id
left join tblProducts ON tblProducts.Id_Product_2 = tblAuxOrderItems.product_id
left join tblSellers ON tblSellers.Id_Seller_2 = tblAuxOrderItems.seller_id
)