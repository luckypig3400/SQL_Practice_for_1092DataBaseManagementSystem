if DB_ID('NTUNHS_IM')IS NOT NULL begin
	use master;
	drop database NTUNHS_IM;
	create database NTUNHS_IM;
end
--sql�y�k����begin�Pend�N�p�PC��JAVA��{}��P�_�����߫�n���檺�h�ӵ{���X�ذ_��
--https://stackoverflow.com/questions/36279671/how-to-set-multiple-values-inside-an-if-else-statement
else begin
	create database NTUNHS_IM;
end

use NTUNHS_IM;
if OBJECT_ID('Account')IS NOT NULL begin
	drop table Account;
end
create table Account(
	BankCodename char(6),
	AccountID char(60),
	Balance int,
	BranchAccount char(60),
	AccountType int,
	PRIMARY KEY(AccountID)
);

if OBJECT_ID('Customer')IS NOT NULL begin
	drop table Customer;
end
create table Customer(
	AccountID char(69),
	FirstName char(32),
	LastName char(32),
	Birthdate date,
	Gender char(3),
	PostalAddress char(255),
	PRIMARY KEY(AccountID)
);

if OBJECT_ID('TransactionLog')IS NOT NULL begin
	drop table TransactionLog;
end
create table TransactionLog(
	AccountID char(69),
	TransactionID char(60),
	TransactionDate date,
	ATM_ID char(60),
	TransactionType char(32),
	TransactionDetail char(255),
	PRIMARY KEY(AccountID,TransactionID)
);

if OBJECT_ID('Bank')IS NOT NULL begin
	drop table Bank;
end
create table Bank(
	BankCodename char(6),
	BankName char(66),
	PRIMARY KEY(BankCodename)
);


--�ϥέק��ƪ��y�k(alter)�A�N�ʧO�欰�]�w�������A�÷s�W�w�]�Ȭ�U
alter table Customer drop column Gender;--�R�����
alter table Customer add Gender char(1);--�s�W���
alter table Customer add constraint Gender DEFAULT 'U' FOR Gender;--�b���s�W�����å[�J�w�]��

insert into Account(BankCodename,AccountID,Balance,BranchAccount,AccountType)
values ('012','082214226',60000,'00412',1);
insert into Account(BankCodename,AccountID,Balance,BranchAccount,AccountType)
values ('012','082214266',50000,'00412',1);
insert into Customer(AccountID,FirstName,LastName,Birthdate,Gender,PostalAddress)
values ('082214226','�`��','��','2000/07/13','M','�a�}�d��1');
insert into Customer(AccountID,FirstName,LastName,Birthdate,Gender,PostalAddress)
values ('082214266','����','�x','1996/06/06','M','�a�}�d��2');
insert into TransactionLog(AccountID,TransactionID,TransactionDate,ATM_ID,TransactionType,TransactionDetail)
values ('082214226','1',GETDATE(),'1','1','�}��s��');
insert into TransactionLog(AccountID,TransactionID,TransactionDate,ATM_ID,TransactionType,TransactionDetail)
values ('082214266','1',GETDATE(),'1','1','�}��s��');
insert into Bank(BankCodename,BankName)
values ('012','�_�@�Ȧ�');
insert into Bank(BankCodename,BankName)
values ('013','�_��Ȧ�');

select * from Account As A, Customer AS C WHERE A.AccountID = C.AccountID;