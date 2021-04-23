if DB_ID('WhoPanda') is not null begin
    use master;
    drop database WhoPanda;
end

CREATE DATABASE WhoPanda;
use WhoPanda;

--題目1
IF OBJECT_ID( 'Member', 'U') IS NOT NULL
    DROP TABLE Member
GO
CREATE TABLE Member
(
    UID VARCHAR(30) NOT NULL PRIMARY KEY,--學號
    Department VARCHAR(30),--系所
    PersonalID VARCHAR(60) NOT NULL UNIQUE,--身分證字號
    LastName NVARCHAR(30),
    FirstName NVARCHAR(30),
    Birthdate DATE,
    Gender VARCHAR(6) Default 'F',
    SchoolStatus VARCHAR(30),--在學狀態
    PhoneNumber VARCHAR(30),
    ContactAddress VARCHAR(60),
    UP_DATE DATETIME --DATETIME為包含時分秒的資料格式
);
GO
--exec sp_helpconstraint @objname='Member';

IF OBJECT_ID( 'Payment', 'U') IS NOT NULL
    DROP TABLE Payment
GO
CREATE TABLE Payment
(
    CardID VARCHAR(36) not null primary key,
    UID VARCHAR(30),
    Balance int,
    PaymentType VARCHAR(30),
    UP_DATE DATETIME,
    FOREIGN KEY (UID) REFERENCES Member(UID)
);
GO
--exec sp_helpconstraint @objname='Payment';

IF OBJECT_ID( 'Product', 'U') IS NOT NULL
    DROP TABLE Product
GO
CREATE TABLE Product
(
    ProductId INT NOT NULL PRIMARY KEY,
    ProductName VARCHAR(60),
    StoreID int not null,
    StoreName VARCHAR(30),
    Price int not null,
    UP_DATE DATETIME
);
GO

IF OBJECT_ID( 'Orders', 'U') IS NOT NULL
    DROP TABLE Orders
GO
CREATE TABLE Orders
(
    OrderId INT NOT NULL PRIMARY KEY,
    OrderTime DATETIME,
    ProductID int,
    Quantity int,--購買數量
    OrderStatus VARCHAR(30),--訂單狀態(已收單、配送中、已送達、已取消)
    UP_DATE DATETIME,
    FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
);
GO

IF OBJECT_ID( 'Trans', 'U') IS NOT NULL
    DROP TABLE Trans
GO
CREATE TABLE Trans
(
    TransId INT NOT NULL PRIMARY KEY,
    PaymentMethod VARCHAR(30),
    Order1ID int,
	Order2ID int,
	Order3ID int,
    UP_DATE DATETIME,
    UID VARCHAR(30),
    FOREIGN KEY(Order1ID) REFERENCES Orders(OrderID),
	FOREIGN KEY(Order2ID) REFERENCES Orders(OrderID),
	FOREIGN KEY(Order3ID) REFERENCES Orders(OrderID),
    FOREIGN KEY(UID) REFERENCES Member(UID)
);
GO
--exec sp_helpconstraint @objname='Trans';






--題目2
insert into Member
VALUES
    ('006616888', '資管系', 'A123456789', '連', '小岳', '1969-06-09', 'M', '教職員', '0912456888', '台北市石牌區明德路365號', GETDATE()),
    ('082214226', '資管系', 'P123666789', '楊', '要成', '2001-07-11', 'M', '學生', '0912456365', '台北市松山區八德路168號', GETDATE()),
    ('032213168', '護理系', 'H223456366', '余', '梓柔', '1999-12-18', 'F', '畢業生', '0968333666', '新北市石三重區崇德路三段63號', GETDATE())

insert into Payment
VALUES
    ('NTUNHSPAY653456453','006616888','60000','北護PAY',GETDATE()),
    ('LP912586468','006616888','96000','LINE PAY',GETDATE()),
    ('NTUNHSPAY9613515384','082214226','6000','北護PAY',GETDATE()),
    ('EasyCard1351354','082214226','3600','悠遊卡',GETDATE()),
    ('NTUNHSPAY695353361','032213168','69','北護PAY',GETDATE())

insert into Product
VALUES
    (1,'柴魚烏龍麵',1,'小石頭',120,GETDATE()),
    (2,'沙茶烏龍麵',1,'小石頭',130,GETDATE()),
    (3,'麻辣火鍋',1,'小石頭',150,GETDATE()),
    (4,'醬燒肉飯',1,'小石頭',120,GETDATE()),
    (5,'今日特鍋',1,'小石頭',160,GETDATE()),
    (6,'原味鍋燒麵',2,'傳奇@甕',70,GETDATE()),
    (7,'純奶蒜香鍋燒麵',2,'傳奇@甕',90,GETDATE()),
    (8,'麻油雞甕',2,'傳奇@甕',110,GETDATE()),
    (9,'大麥克',3,'M金拱門M',72,GETDATE()),
    (10,'冰炫風',3,'M金拱門M',55,GETDATE()),
    (11,'大薯',3,'M金拱門M',55,GETDATE()),
    (12,'麥克雞塊*6',3,'M金拱門M',60,GETDATE())

insert into Orders
VALUES
    (1,GETDATE(),1,5,'已收單',GETDATE()),
    (2,GETDATE(),3,3,'已收單',GETDATE()),
    (3,GETDATE(),6,9,'配送中',GETDATE()),
    (4,GETDATE(),10,9,'配送中',GETDATE()),
    (5,GETDATE(),2,3,'配送中',GETDATE()),
    (6,GETDATE(),11,8,'配送中',GETDATE()),
    (7,GETDATE(),9,8,'配送中',GETDATE()),
    (8,GETDATE(),7,8,'配送中',GETDATE()),
    (9,GETDATE(),8,6,'配送中',GETDATE()),
    (10,GETDATE(),11,12,'配送中',GETDATE()),
    (11,GETDATE(),12,10,'配送中',GETDATE()),
    (12,GETDATE(),4,3,'配送中',GETDATE()),
    (13,GETDATE(),1,5,'已收單',GETDATE()),
    (14,GETDATE(),3,3,'已收單',GETDATE()),
    (15,GETDATE(),6,9,'已收單',GETDATE()),
    (16,GETDATE(),10,9,'已送達',GETDATE()),
    (17,GETDATE(),2,3,'已送達',GETDATE()),
    (18,GETDATE(),11,8,'配送中',GETDATE()),
    (19,GETDATE(),9,8,'配送中',GETDATE()),
    (20,GETDATE(),7,8,'已收單',GETDATE()),
    (21,GETDATE(),8,6,'配送中',GETDATE()),
    (22,GETDATE(),11,12,'已取消',GETDATE()),
    (23,GETDATE(),12,10,'已取消',GETDATE()),
    (24,GETDATE(),11,9,'已取消',GETDATE()),
    (25,GETDATE(),2,5,'已送達',GETDATE()),
    (26,GETDATE(),8,3,'已送達',GETDATE()),
    (27,GETDATE(),10,36,'已送達',GETDATE()),
    (28,GETDATE(),6,9,'已收單',GETDATE()),
    (29,GETDATE(),10,9,'已送達',GETDATE()),
    (30,GETDATE(),2,3,'已送達',GETDATE()),
    (31,GETDATE(),11,8,'已送達',GETDATE()),
    (32,GETDATE(),9,8,'已送達',GETDATE()),
    (33,GETDATE(),7,8,'已收單',GETDATE()),
    (34,GETDATE(),8,6,'配送中',GETDATE()),
    (35,GETDATE(),11,12,'已取消',GETDATE()),
    (36,GETDATE(),6,9,'已取消',GETDATE())

INSERT INTO Trans
VALUES
    (1,'北護PAY',1,2,3,GETDATE(),'006616888'),
    (2,'北護PAY',4,5,NULL,GETDATE(),'006616888'),
    (3,'LINE PAY',6,7,8,GETDATE(),'006616888'),
    (4,'北護PAY',9,10,NULL,GETDATE(),'082214226'),
    (5,'悠遊卡',11,12,NULL,GETDATE(),'082214226'),
    (6,'北護PAY',13,14,15,GETDATE(),'006616888'),
    (7,'北護PAY',16,17,NULL,GETDATE(),'006616888'),
    (8,'LINE PAY',18,19,20,GETDATE(),'006616888'),
    (9,'LINE PAY',21,22,NULL,GETDATE(),'006616888'),
    (10,'LINE PAY',23,24,NULL,GETDATE(),'006616888'),
    (11,'LINE PAY',25,26,NULL,GETDATE(),'006616888'),
    (12,'LINE PAY',27,28,NULL,GETDATE(),'006616888'),
    (13,'北護PAY',29,30,NULL,GETDATE(),'032213168'),
    (14,'北護PAY',31,32,NULL,GETDATE(),'032213168'),
    (15,'北護PAY',33,34,NULL,GETDATE(),'032213168'),
    (16,'北護PAY',35,36,NULL,GETDATE(),'032213168')







--題目三
SELECT M.UID, M.SchoolStatus, M.PhoneNumber FROM Member as M

UPDATE Member
SET
    SchoolStatus = '四技在學生',
    PhoneNumber = '0969168666',
    UP_DATE = GETDATE()
OUTPUT inserted.UID, inserted.SchoolStatus, inserted.PhoneNumber
WHERE PersonalID = 'P123666789'
GO






--題目四
SELECT T.TransId, T.PaymentMethod, O.OrderStatus, M.ContactAddress as '送餐地點',
PM.CardID, PM.PaymentType,
P.StoreName,P.ProductName,P.Price,
LastName + ' ' + FirstName as '姓名',
M.UID + '/' + cast(M.Birthdate as varchar) + '/' + M.Gender as '基本資訊'
FROM Member as M, Payment as PM,Product as P,Trans as T,Orders as O
WHERE M.FirstName = '小岳' and T.UID = M.UID and T.Order1ID = O.OrderId and O.ProductID = P.ProductId





--題目5
SELECT T.TransId, T.PaymentMethod, O.OrderStatus, M.ContactAddress as '送餐地點',
PM.CardID, PM.PaymentType,
P.StoreName,P.ProductName,P.Price,
LastName + ' ' + FirstName as '姓名',
M.UID + '/' + cast(M.Birthdate as varchar) + '/' + M.Gender as '基本資訊'
into #PERSONAL_HISTORY
FROM Member as M, Payment as PM,Product as P,Trans as T,Orders as O
WHERE M.FirstName = '小岳' and T.UID = M.UID and T.Order1ID = O.OrderId and O.ProductID = P.ProductId

SELECT * from #PERSONAL_HISTORY