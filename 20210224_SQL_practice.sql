use NTUNHS_IM;

create table Customer(
	FName char(50),
	LName char(50),
	Address char(50),
	City char(50),
	Country char(50),
	BDate datetime
);
--4. ���J5����Ʀ�Table
-- �Ĥ@��
insert into Customer(FName,LName,Address,City,Country,BDate)
values('CY','Lien','NTUNHS', 'Taiepi','Taiwan', '19800101');

--5. �d�ߩҦ����
select * from Customer;

-- �ĤG��
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('AAA','Fu','NTU', 'Taipei','Taiwan', '20010301');
-- �ĤT��
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('GY','Chen','FJU', 'New Taipei City','Taiwan', '20010801');
-- �ĥ|��
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('KK','Wang','NCKU', 'Tainan','Taiwan', '19950630');
-- �Ĥ���
INSERT INTO Customer (FName, LName, Address, City, Country, BDate)
VALUES ('NC','Lin','NUTC', 'Taichung','Taiwan', '19970515');

select * from Customer;