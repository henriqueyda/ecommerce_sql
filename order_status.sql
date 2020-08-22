CREATE TABLE tblOrderStatus(
	Id_Order_Status INT IDENTITY(1,1) PRIMARY KEY,
	Order_Status VARCHAR(50)
)

INSERT INTO tblOrderStatus(
	Order_Status
)(
	SELECT DISTINCT order_status FROM tblAuxOrdersDataset
)