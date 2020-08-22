CREATE TABLE tblProductCategory(
	Id_Product_Category INT IDENTITY(1,1) PRIMARY KEY,
	Product_Category_Name VARCHAR(500)
)

INSERT INTO tblProductCategory(
	Product_Category_Name
)(
	SELECT DISTINCT product_category_name FROM tblAuxProducts
)