-- Queries nivelamento 
-- total de compras por mês/por cidade/por estado do vendedor do produto

select
	seller.Id_Seller,
	seller.Id_Seller_2,
	cidade.Nome_Cidade,
	estado.Abrev_Estado,
	format(orders.Order_Purchase_timestamp,'MM/yy') as Purchase_Month_Year,
	orderitem.Id_Product,
	sum(orderitem.Price) as Total_Amount
from tblSellers seller
inner join tblLocalizacao localizacao on seller.Seller_Localizacao = localizacao.Id_Localizacao
inner join tblCidade cidade on cidade.Id_Cidade = localizacao.Id_Cidade
inner join tblEstado estado on estado.Id_Estado = cidade.Id_Estado
inner join tblOrderItems orderitem on orderitem.Id_Seller = seller.Id_Seller
inner join tblOrdersDataset orders on orders.Id_Order = orderitem.Id_Order
group by seller.Id_Seller, Id_Seller_2, cidade.Nome_Cidade, estado.Abrev_Estado, format(orders.Order_Purchase_timestamp,'MM/yy'), orderitem.Id_Product
order by Id_Seller, Purchase_Month_Year

select * from tblOrderReviews

--  pega o último ano em que houve venda, e mostra uma query com a média de total de venda de cada mês

declare @max_year int
set @max_year = (select MAX(YEAR(orders.Order_Purchase_timestamp)) from tblOrdersDataset orders)

select
	sum(orderitem.Price) as Total_Amount,
	MONTH(orders.Order_Purchase_timestamp) as Purchase_Month,
	YEAR(orders.Order_Purchase_timestamp) as Purschase_Last_Year
from tblOrderItems orderitem
inner join tblOrdersDataset orders on orders.Id_Order = orderitem.Id_Order
group by MONTH(orders.Order_Purchase_timestamp), YEAR(orders.Order_Purchase_timestamp)
having YEAR(orders.Order_Purchase_timestamp) = @max_year
order by Total_Amount

-- Qual produto teve o menor score do último ano ?

declare @max_year int
set @max_year = (select MAX(YEAR(orders.Order_Purchase_timestamp)) from tblOrdersDataset orders)

select 
	AVG(CAST(reviews.Review_Score AS float)) Average_Score,
	orderitem.Id_Product,
	YEAR(orders.Order_Purchase_timestamp) Purchase_Year
from tblOrderReviews reviews
inner join tblOrdersDataset orders on orders.Id_Order = reviews.Id_Order
inner join tblOrderItems orderitem on orders.Id_Order = orderitem.Id_Order
group by orderitem.Id_Product, YEAR(orders.Order_Purchase_timestamp)
having YEAR(orders.Order_Purchase_timestamp) = @max_year
order by Average_Score ASC

-- No último ano, qual a média de tempo de resposta das reviews, em minutos.

declare @max_year int
set @max_year = (select MAX(YEAR(reviews.Review_Creation_Date)) from tblOrderReviews reviews)

select 
	avg(datediff(minute,reviews.Review_Creation_Date, reviews.Review_Answer_Timestamp)) Response_Time_Average,
	month(reviews.Review_Creation_Date) Creation_Month,
	year(reviews.Review_Creation_Date) Creation_Year
from tblOrderReviews reviews
group by month(reviews.Review_Creation_Date), year(reviews.Review_Creation_Date)
having year(reviews.Review_Creation_Date) = @max_year
order by Response_Time_Average

--faturamento acumulado até agosto de 2017 e faturamento mês a mês no resto

create table tblFaturamento(
	Price FLOAT,
	Purchase_Month_Year VARCHAR(50)
)

INSERT INTO tblFaturamento(
	Price,
	Purchase_Month_Year
)
(
select 
	orderitem.Price as Price,
	CASE WHEN year(orders.Order_Purchase_timestamp)*100 + month(orders.Order_Purchase_timestamp) <= 201708 THEN 'Acumulado'
		 WHEN year(orders.Order_Purchase_timestamp)*100 + month(orders.Order_Purchase_timestamp) > 201708 THEN format(orders.Order_Purchase_timestamp,'MM/yy')
	END AS Purchase_Month_Year
from tblOrderItems orderitem
inner join tblOrdersDataset orders on orderitem.Id_Order = orders.Id_Order
)

select
	sum(Price) Faturamento,
	Purchase_Month_Year
from tblFaturamento
group by Purchase_Month_Year
order by Purchase_Month_Year