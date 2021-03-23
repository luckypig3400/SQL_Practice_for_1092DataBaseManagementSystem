use NTUNHS_IM;

create table Customer(
	FName char(50),
	LName char(50),
	Address char(50),
	City char(50),
	Country char(50),
	BDate datetime
);
--4. 插入5筆資料至Table
-- 第一筆
insert into Customer(FName,LName,Address,City,Country,BDate)
values('CY','Lien','NTUNHS', 'Taiepi','Taiwan', '19800101');

--5. 查詢所有資料
select * from Customer;

-- 第二筆
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('AAA','Fu','NTU', 'Taipei','Taiwan', '20010301');
-- 第三筆
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('GY','Chen','FJU', 'New Taipei City','Taiwan', '20010801');
-- 第四筆
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('KK','Wang','NCKU', 'Tainan','Taiwan', '19950630');
-- 第五筆
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('NC','Lin','NUTC', 'Taichung','Taiwan', '19970515');

select * from Customer;