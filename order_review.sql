CREATE TABLE tblAuxOrderReviews(
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(50),
	review_comment_message VARCHAR(500),
	review_creation_date DATETIME,
	review_answer_timestamp DATETIME,
)

BULK INSERT tblAuxOrderReviews
FROM "C:\55151_195341_bundle_archive\olist_order_reviews_dataset.csv"
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='0x0a',
    BATCHSIZE=250000,
    TABLOCK
);


CREATE TABLE tblOrderReviews(
	Id_Review INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Id_Review_2 VARCHAR(50),
	Id_Order INT, 
    Review_Score INT,
    Review_Comment_Title VARCHAR(50),
    Review_Comment_Message VARCHAR(500),
	Review_Creation_Date DATETIME,
	Review_Answer_Timestamp DATETIME
	CONSTRAINT [FK_tblOrderReviews_tblOrdersDataset] FOREIGN KEY ([Id_Order]) REFERENCES [dbo].[tblOrdersDataset]([Id_Order])
)

INSERT INTO tblOrderReviews(
	Id_Review_2,
	Id_Order,
	Review_Score,
	Review_Comment_Title,
	Review_Comment_Message,
	Review_Creation_Date,
	Review_Answer_Timestamp
	)
	(SELECT 
		review_id,
		(SELECT TOP 1 Id_Order FROM tblOrdersDataset od
		WHERE od.Id_Order_2 = aux.order_id),
		review_score,
		review_comment_title,
		review_comment_message,
		review_creation_date,
		review_answer_timestamp
	FROM tblAuxOrderReviews aux)