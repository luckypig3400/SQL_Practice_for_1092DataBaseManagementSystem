USE BankHW5;
-- 說明: 請使用觸發(Trigger)修改[作業3]綜合語法，規則如下:

-- 1.請使用AFTER觸發程序，改寫原本程式，在新增交易紀錄後，自動更新LOG_SEG流水號 (30)
CREATE TRIGGER AutoUpdateLOG_SEQafterInsert
ON Trans AFTER insert
AS
declare @formattedDate varchar(9) = CONVERT(varchar, GETDATE(), 112);
declare @todayLogCount int = (select COUNT(SDATE) FROM LOG_SEQ WHERE SDATE = @formattedDate);
declare @todayTransCount int = (select LOG_COUNT FROM LOG_SEQ WHERE SDATE = @formattedDate);
IF @todayLogCount = 0 begin
	print('此為今日的第一筆交易');
	insert into LOG_SEQ values(@formattedDate , 1);
end
else if @todayTransCount = 999999 begin
	print('很抱歉!已達本系統單日交易量上限，將取消此交易，請明日再來');
	ROLLBACK
end
else begin
	set @todayTransCount = @todayTransCount + 1;
	print('此為今日的第' + CAST(@todayTransCount as varchar) + '筆交易');
	update LOG_SEQ set LOG_COUNT = @todayTransCount where SDATE = @formattedDate;
end

insert into Trans VALUES('6', '20210620_000013', GETDATE(), 'A03', 'D66', N'信義區60坪地契乙份', GETDATE(), '006');

	
-- 2.請使用INSTEAD OF觸發程序，在操作新增交易紀錄時，不需要輸入TranID(範例格式: 20210524_000001)。
--將TranID新增至交易紀錄取代原本新增交易紀錄動作。並自動更新LOG_SEG流水號 (70)
CREATE TRIGGER AutoGenerateTranIDwhenInsert
on Trans
INSTEAD OF INSERT
AS
SET NOCOUNT ON; --不顯示 (?個資料列受到影響)
print('將自動為您的交易進行編號')


INSERT INTO Trans	(AccID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
			VALUES	('3', GETDATE(), 'G03', 'D68', N'RTX 3060Ti', GETDATE(), '003')

select * from Trans
select * from LOG_SEQ

use master;