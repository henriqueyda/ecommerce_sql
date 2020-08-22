CREATE TABLE tblPaymentType(
	Id_Payment_Type INT IDENTITY(1,1) PRIMARY KEY,
	Payment_Type VARCHAR(50)
)

INSERT INTO tblPaymentType(
	Payment_Type
)(
	SELECT DISTINCT payment_type FROM tblAuxOrderPayments
)
