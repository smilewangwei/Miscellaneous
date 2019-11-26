--CREATE TABLE product
--(
--product NVARCHAR(20),
--category NVARCHAR(20),
--color NVARCHAR(20),
--[weight] NVARCHAR(20),
--price INT
--)
--SELECT * FROM [dbo].[product]
--INSERT INTO [dbo].[product] VALUES('ProductA','CategoryA','Yellow',5.6,100)
--INSERT INTO [dbo].[product] VALUES('ProductB','CategoryA','Red',3.7,200)
--INSERT INTO [dbo].[product] VALUES('ProductC','CategoryB','Blue',10.3,300)
--INSERT INTO [dbo].[product] VALUES('ProductD','CategoryB','Black',7.8,400)

--CREATE TABLE dbo.[Order]
--(
--    OrderID int NOT NULL,
--    Name NVARCHAR(20) NULL,
--    OrderDate DATETIME NULL,
--    Store NVARCHAR(20) NULL,
--    Product NVARCHAR(20) NULL,
--    Quantity int NULL,
--    Amount int NULL,
--);

--INSERT INTO dbo.[Order] VALUES(1,'CategoryA','2018-01-01','StoreA','ProductA',1,100)
--INSERT INTO dbo.[Order] VALUES(1,'CategoryA','2018-01-01','StoreA','ProductB',1,200)
--INSERT INTO dbo.[Order] VALUES(1,'CategoryA','2018-01-01','StoreA','ProductC',1,300)
--INSERT INTO dbo.[Order] VALUES(2,'CategoryB','2018-01-12','StoreB','ProductB',1,200)
--INSERT INTO dbo.[Order] VALUES(2,'CategoryB','2018-01-12','StoreB','ProductD',1,400)
--INSERT INTO dbo.[Order] VALUES(3,'CategoryC','2018-01-12','StoreC','ProductB',1,200)
--INSERT INTO dbo.[Order] VALUES(3,'CategoryC','2018-01-12','StoreC','ProductC',1,300)
--INSERT INTO dbo.[Order] VALUES(3,'CategoryC','2018-01-12','StoreC','ProductD',1,400)
--INSERT INTO dbo.[Order] VALUES(4,'CategoryA','2018-01-01','StoreD','ProductD',2,800)
--INSERT INTO dbo.[Order] VALUES(5,'CategoryB','2018-01-23','StoreB','ProductA',1,100)


--CREATE TABLE dbo.Store
--(
--Store NVARCHAR(20),
--City NVARCHAR(20)
--)


--INSERT INTO	dbo.Store VALUES('StoreA','CityA')
--INSERT INTO	dbo.Store VALUES('StoreB','CityA')
--INSERT INTO	dbo.Store VALUES('StoreC','CityB')
--INSERT INTO	dbo.Store VALUES('StoreD','CityC')
--INSERT INTO	dbo.Store VALUES('StoreE','CityD')
--INSERT INTO	dbo.Store VALUES('StoreF','CityB')
SELECT * FROM [dbo].[product]
SELECT * FROM [dbo].[Order]
SELECT * FROM [dbo].[Store]



--��һ�⣬����㣬û���濴��or
SELECT * FROM [dbo].[product] WHERE category=N'CategoryA' AND color =N'Yellow' OR [weight]>5

SELECT * FROM [dbo].[product] WHERE category=N'CategoryA' AND (color =N'Yellow' OR [weight]>5) 

 
--�ڶ���,ȱ�ٱ�Ҫ����ʾ,orderid,name,����ɾۺ�����
--�޸�
SELECT SUM(Amount),COUNT(*),SUM(Quantity) FROM dbo.[Order] GROUP BY OrderID,Name HAVING SUM(Amount) >800 ORDER  BY SUM(Amount) desc	

--��
SELECT OrderID,Name,SUM(Amount) AS �����ܽ��,COUNT(*) AS �ܹ��򶩵���,SUM(Quantity) AS �ܹ����� FROM [dbo].[Order] GROUP BY OrderID,Name HAVING SUM(Amount)>800 ORDER BY SUM(Amount) desc


--������
SELECT city, COUNT( a.Store) AS �ܵ�����,COUNT( a.Name) AS �ܹ�������,SUM( a.Amount) AS �ܹ����� FROM dbo.[Order] a RIGHT JOIN dbo.Store b ON b.Store = a.Store GROUP BY b.City
--��
SELECT city, COUNT(distinct a.Store) AS �ܵ�����,COUNT(DISTINCT a.Name) AS �ܹ�������,SUM( a.Amount) AS �ܹ����� FROM dbo.[Order] a RIGHT JOIN dbo.Store b ON b.Store = a.Store GROUP BY b.City

--������,where��������
SELECT b.orderid,AVG(b.Amount)AS ƽ��������� FROM dbo.product a,dbo.[Order] b
WHERE a.product=b.Product AND a.category='CategoryA' GROUP BY b.OrderID
--��
SELECT distinct c.Name,d.OrderID,d.ƽ��������� FROM dbo.[Order] c RIGHT JOIN (SELECT b.orderid,AVG(b.Amount)AS ƽ��������� FROM dbo.product a JOIN dbo.[Order] b ON a.product=b.Product WHERE a.category='CategoryA' GROUP BY b.OrderID ) d ON d.OrderID = c.OrderID


--������ ˼·�ȶ����ݽ���͸�� ��ȡ�����е���������ó����ܣ��ٶԻ��ܵ����ݽ��п������� 
--��
SELECT * FROM dbo.Store a JOIN dbo.[Order] b ON b.Store = a.Store
SELECT * FROM (SELECT c.City,c.Name,RANK()OVER(PARTITION BY c.City ORDER BY c.sum_a desc) AS ro FROM (
SELECT a.City,b.Name,SUM(b.Amount) AS sum_a FROM dbo.Store a JOIN dbo.[Order] b ON b.Store = a.Store 
GROUP BY a.City,b.Name
) c ) d WHERE d.ro=2