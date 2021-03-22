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

drop table if exists Customer; --SQL Server2016�}�l�䴩 �R���w�s�b�����
create table Customer(--�b�m�ߤ��٬��ӤH���
	userID char(66) primary key,--�ӤH�b�����G�M�Ȧ�b�������P��
	--���ӬO���o�ӤH�b�o�������U�Ƚs��
	--�Ȥ�s�������D��(�p�����Ҧr�����i����)
	AccID char(69),
	FirstName char(32),
	LastName char(32),
	Birthdate date,
	Gender char(3),
	PostalAddress char(255),
	City char(30),
	Country char(30),
	UpdateDate date,
	ChangedPersonnel char(60),--���ʤH
);

if OBJECT_ID('Bank')IS NOT NULL begin
	drop table Bank;
end
create table Bank(
	BankID char(6),
	BankName char(66),
	BankAddress char(255),
	PRIMARY KEY(BankID),
);

if OBJECT_ID('Account')IS NOT NULL begin
	drop table Account;
end
create table Account(
	BankID char(6),
	AccID char(69),
	Balance int,
	BranchAccID char(60),
	AccType char(30),
	UpdateDate date,
	ChangedPersonnel char(60),--���ʤH
	cID char(66),--�n�i�����p�A��Ʈ榡�P���ץ����P�n���p�����ۦP
	--customerID�O���o���Ȧ�b��O�ֶ}���s����Customer���
	PRIMARY KEY(AccID),
	foreign key(cID) references Customer(userID),
	Foreign Key(BankID) References Bank(BankID)
);

if OBJECT_ID('TransactionLog')IS NOT NULL begin
	drop table TransactionLog;
end
create table TransactionLog(
	AccID char(69),
	traID char(60),
	traDate date,
	ATM_ID char(60),
	traType char(32),
	traDetail char(255),
	UpdateDate date,
	ChangedPersonnel char(60),--���ʤH
	traAccID char(69),--��b��H���Ȧ�b��
	PRIMARY KEY(AccID,traID),
	Foreign Key(AccID) references Account(AccID)
);



--�ϥέק��ƪ��y�k(alter)�A�N�ʧO�欰�]�w�������A�÷s�W�w�]�Ȭ�U
alter table Customer drop column Gender;--�R�����
alter table Customer add Gender char(1);--�s�W���
alter table Customer add constraint Gender DEFAULT 'U' FOR Gender;--�b���s�W�����å[�J�w�]��



insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('yaocheng0822','082214226','�`��','��','2000/07/13','M','�a�}�d��1','�x�_','�x�W',GETDATE(),'���`��');
insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('test1userID','07876467','�@','����','1990/06/03','M','�a�}�d��2','�x�_','�x�W',GETDATE(),'���դ@');
insert into Customer(userID,AccID,FirstName,LastName,Birthdate,Gender,PostalAddress,City,Country,UpdateDate,ChangedPersonnel)
values ('conan8967','896787653','�_�n','����t','1999/06/9','M','Tokyo Hot Street 69','�F��','�饻',GETDATE(),'����t�_�n');

insert into Bank(BankID,BankName,BankAddress)
values ('012','�_�@�Ȧ�','�x�_���_��ϩ��w��365��');
insert into Bank(BankID,BankName,BankAddress)
values ('013','�a�y�Ȧ�','�a�y���C�Ө���');

insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('012','082214226',60000,'00333','�����s�ڤ�',GETDATE(),'���`��','yaocheng0822');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','082214226666',3000000,'00333','�w���s�ڤ�',GETDATE(),'���`��','yaocheng0822');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('012','07876467',60000,'00412','�����s�ڤ�',GETDATE(),'���դ@','test1userID');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','08435162776',30000,'00412','�w���s�ڤ�',GETDATE(),'���դ@','test1userID');
insert into Account(BankID,AccID,Balance,BranchAccID,AccType,UpdateDate,ChangedPersonnel,cID)
values ('013','896787653',660000,'00412','�����s�ڤ�',GETDATE(),'����t�_�n','conan8967');

insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','1',GETDATE(),'3','�s��','�}��s��',GETDATE(),'���`��');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','2',GETDATE(),'3','����','���մ���',GETDATE(),'���`��');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('082214226','3',GETDATE(),'3','�s��','�ʫ��Y�ڹw�ƪ�',GETDATE(),'���`��');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','1',GETDATE(),'3','�s��','�}��s��',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','2',GETDATE(),'3','�s��','dwfesgtrgtrh',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','3',GETDATE(),'3','�s��','etwretrdwfesgtrgtrh',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','4',GETDATE(),'3','����','hgfhrhgfhytdh',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','5',GETDATE(),'3','����','yjuyj',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','6',GETDATE(),'6','����','otho',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','7',GETDATE(),'6','����','???what???',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('07876467','8',GETDATE(),'6','�s��','QwQ OuO',GETDATE(),'���դ@');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','1',GETDATE(),'33','�s��','�}��s��',GETDATE(),'����t�_�n');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','2',GETDATE(),'67431','����','���d�u��ƥ�',GETDATE(),'����t�_�n');
insert into TransactionLog(AccID,traID,traDate,ATM_ID,traType,traDetail,UpdateDate,ChangedPersonnel)
values ('896787653','3',GETDATE(),'69696','�s��','�}�׳��S',GETDATE(),'����t�_�n');



--3. �ϥάd��(SELECT)�y�k�d�ߡA�Y�ӱb�᪺�Ҧ���������A����������]�t�H�U��� (�d�ߵ��G���~0���A�C�����2���A�X�p14��)- �Ȧ�N���B�ӤH�b���B�Ȧ�b���B����s���B����ɶ��B��������B������e
select B.BankID,C.userID,C.AccID,T.traID,T.traDate,T.traType,T.traDetail 
from TransactionLog As T, Customer as C,Bank as B , Account as A 
where A.AccID = T.AccID and C.AccID = T.AccID and A.BankID = B.BankID;

select * from Account As A, Customer AS C WHERE A.AccID = C.AccID;