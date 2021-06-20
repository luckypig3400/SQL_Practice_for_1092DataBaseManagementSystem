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
declare @formattedDate varchar(9) = CONVERT(varchar, GETDATE(), 112);
declare @todayTransCount int = (select LOG_COUNT FROM LOG_SEQ WHERE SDATE = @formattedDate);
declare @idToMerge varchar(15) = (select RIGHT('000000' + cast((@todayTransCount+1) as varchar), 6));
declare @newTranID varchar(15) = @formattedDate + '_' + @idToMerge;
SET NOCOUNT ON; --不顯示 (?個資料列受到影響)
if (select TranID from inserted) is NULL begin
	print('將自動為您的交易進行編號')

	select * into #tempTable from inserted;--把輸入的值存入暫存表
	--因為無法更新inserted table的值，所以用暫存表來更新TranID
	update #tempTable set TranID = @newTranID;

	INSERT INTO Trans select * from #tempTable;
	DROP TABLE #tempTable
	print('成功新增交易紀錄，您的交易編號為:' + @newTranID);
end
else begin
	print('正在檢查您所輸入的交易編號是否正確')
	if(select TranID from inserted) = @newTranID begin
		print('您輸入的ID為正確的序號，即將新增')
		insert into Trans select * from inserted;
	end
	else begin
		print('您輸入的ID錯誤!將不會新增');
		print('請檢查後再嘗試，或是不輸入ID系統會自動為您編號');
	end
end



INSERT INTO Trans	(AccID, TranTime, AtmID, TranType, TranNote, UP_DATETIME, UP_USR)
			VALUES	('3', GETDATE(), 'G03', 'D69', N'RTX 3080Ti', GETDATE(), '003')

INSERT INTO Trans VALUES('3', 'tranID666', GETDATE(), 'G03', 'D69', N'RTX 3090', GETDATE(), '003')

INSERT INTO Trans VALUES('3', '20210620_000019', GETDATE(), 'G03', 'D69', N'RTX 3090', GETDATE(), '003')

use master;