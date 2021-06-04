--說明1: 請針對以及，製作預存程序以及函數，並提供範例SQL測試程式，測試程式請寫在建立預存程序(CREATE PROCEDURE)以及建立函數(CREATE FUNCTION)程式碼之後。請依照題號順序完成
--說明2 : 建立預存程序請儲存成sp.sql；建立函數請儲存成func.sql。
--說明3 :此作業共10題，每題30分
-- - 10分: 資料準備，包含新增資料內容做為測試使用
-- - 10分: SP以及Function的功能與內容
-- - 10 分: 測試程式

--提示:  某些功能無法實作，請以註解的方式說明原因，例如請上課提到那些功能適合使用預存程序，哪些適合使用函數，請參考，CREATE FUNCTION中的"限制事項 "提到
-- - 使用者定義函數不能用來執行修改資料庫狀態的動作。
-- - 使用者定義函式不得包含具有資料表作為其目標的 OUTPUT INTO 子句。

use BankHW5

--1. [作業1]-[分行帳號資料表]，輸入分行帳號，並回傳分行名稱
-- - 使用變數宣告的方式，將分行帳號作為變數輸入
-- - 執行預存程序時，需輸入分行帳號，輸出以TABLE型別的參數回傳查詢結果

CREATE PROCEDURE BankNameQuery
@branchID varchar(30)
AS
SELECT * from BankBranch WHERE BranchID = @branchID

EXEC BankNameQuery @branchID = '10'



--2. [作業1] 問題3 - 新增資料表與更新關聯( SelectDB.sql) - 3.2題-以TABLE型別的參數回傳查詢結果
-- - 使用變數宣告的方式，將排序選項作為變數輸入，其中需將[次數]升冪排序設定為預設排序
--   - 當排序=1時，顯示升冪以升冪排序，
--   - 當排序=2時，顯示降冪以降冪排序；
--   - 執行預存程序時，輸出以TABLE型別的參數回傳查詢結果
CREATE PROCEDURE HW1_Q3
@sort int
AS
if @sort = 1 begin
	select C.LName + ', ' + C.FName as 姓名,cast(C.BDate as varchar(15)) +', Sex:'+ C.Sex as 生日與性別,
	C.City +', '+ C.Country as 城市與國籍, A.AccID as 帳號, B.BranchBankName as 分行名稱, A.Balance as 餘額
	from Account as A, BankBranch as B, Customer as C 
	where C.ID = A.ID and A.BranchID = B.BranchID
	order by A.AccID ASC
end;
else begin
	select C.LName + ', ' + C.FName as 姓名,cast(C.BDate as varchar(15)) +', Sex:'+ C.Sex as 生日與性別,
	C.City +', '+ C.Country as 城市與國籍, A.AccID as 帳號, B.BranchBankName as 分行名稱, A.Balance as 餘額
	from Account as A, BankBranch as B, Customer as C 
	where C.ID = A.ID and A.BranchID = B.BranchID
	order by A.AccID DESC
end;

EXEC HW1_Q3 @sort = 1


--### 預存程序與函數
--1. 預存程序 CREATE PROCEDURE
--2. 函數 CREATE FUNCTION

--### 特殊程式控制
--1. WAITFOR (時間延遲, Delay）
--2. RETURN (用在Function以及Stored Procedure)
--3. EXEC(用在Stored Procedure或是SQL Script)
--4. NULL, ISNULL, NULLIF, COALESCE

--### 錯誤處理(13.7) -自習
--1. RAISERROR
--2. @@ERROR
--3. TRY...CATCH
--4. THROW



--3. 載入[練習9.mdf]使用LEFT JOIN結合四個資料表，並加入搜尋條件，輸入客戶編號，查詢該客戶的訂單紀錄與相關資訊
-- - 四個資料表為: 訂單, 客戶, 訂購項目, 書籍
-- - 顯示欄位依左至右為: 訂單編號, 下單日期, 書籍名稱, 書籍數量, 客戶名稱, 客戶聯絡人, 客戶地址, 客戶電話
use 練習09
go

drop procedure searchOrder
create procedure searchOrder
@customerID int
AS
	select	O.訂單編號, O.下單日期, B.書籍名稱, I.數量,
			C.客戶名稱, C.聯絡人,C.地址,C.電話
	from 訂單 as O, 客戶 as C, 訂購項目 as I
	left join 書籍 as B on I.書籍編號 = B.書籍編號
	where	O.客戶編號 = @customerID and O.客戶編號 = C.客戶編號
			and O.訂單編號 = I.訂單編號

EXEC searchOrder @customerID=1



--4. [作業3]綜合語法: 新增一筆交易紀錄，並同步更新LOG_SEQ
-- - LOG_SEQ中的LOG_COUNT需自動加1
-- - 需回傳結果是否成功
use BankHW5

create procedure insertTranRecord
@accID varchar(10), @atmID varchar(3), @tranType varchar(3), @note nvarchar(100), @updateUser int
AS
declare @formattedDate varchar(30) = CONVERT(varchar, GETDATE(), 112);
if (select SDATE from LOG_SEQ where SDATE = @formattedDate) is null
begin
	insert into LOG_SEQ values (@formattedDate, '0');
	declare @todayFirstID varchar(36) = @formattedDate + '_' + (select RIGHT('000000'+ '1' ,6));
	insert into Trans VALUES(@accID, @todayFirstID, GETDATE(), @atmID, @tranType, @note, GETDATE(), @updateUser);
	update LOG_SEQ set LOG_COUNT = 1 where SDATE = @formattedDate;
end;
else begin
	declare @newID int = (select LOG_COUNT from LOG_SEQ where SDATE = @formattedDate) + 1;
	declare @id2wrtie varchar(36) = @formattedDate + '_' + (select RIGHT('000000' + cast(@newID as varchar), 6));
	insert into Trans VALUES(@accID, @id2wrtie, GETDATE(), @atmID, @tranType, @note, GETDATE(), @updateUser);
	update LOG_SEQ set LOG_COUNT = @newID where SDATE = @formattedDate;
end;

EXEC insertTranRecord
@accID=3,@atmID='A03',@tranType='C87', @note=N'Coin Master Coin Package $10Millin ○( ＾皿＾)っ', @updateUser=3


--5. [作業3]綜合語法 -第4題 - 製作帳號密碼驗證，輸入帳號與密碼，並回傳狀態，並顯示以下結果
-- - 帳號不存在
-- - 密碼錯誤
-- - 帳密正確

--個人資訊資料參考
	--Customer (ID,Lname,FName,BDate,Sex,Address,City,Country,UP_Date,UP_User)
	--('0', 'CY', 'Lien', '19120101', 'M', 'Neihu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('001', 'LJ', 'KUO', '19981002', 'F', 'Neihu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('002', 'CW', 'Lin', '19981002', 'F', 'Tianmu', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('003', 'DW', 'Wang', '19981002', 'M', 'Beitou', 'Taipei', 'Taiwan', GETDATE(), '0'),
	--('006', 'OwO', 'YA', '20030331', 'F', 'Tianmu', 'Taipei', 'Taiwan', GETDATE(), '0');
--個人資訊資料參考
--使用者密碼輸入區起使

create Procedure customerLogin
@inputID varchar(10) = '006', @inputPWD varchar(30) = 'pwd0062003'
AS
	if (select PWD from Customer where ID = @inputID) = HASHBYTES('SHA2_512', @inputPWD)
	begin
		print(N'ヾ(≧▽≦*)o密碼正確~~~');
	end;
	else if @@ROWCOUNT = 0
	begin
		--Simple check for SELECT query empty result
		--https://stackoverflow.com/questions/2884996/simple-check-for-select-query-empty-result
		print(N'`(っ °Д °;)っ帳號不存在!!!')
	end;
	else begin
		print(N'`(*>﹏<*)′密碼錯誤!!!');
	end;

exec customerLogin
exec customerLogin '666','odsoifja666'

--6. 隱藏題 柯文哲慣用手勢
CREATE TABLE RightHand(
	ID int,
	拇指 int,
	食指 int,
	中指 int,
	無名指 int,
	小指 int
)
INSERT INTO RightHand 
VALUES	(1,1,0,0,0,0),
		(2,0,1,0,0,0),
		(3,0,0,1,0,0),
		(4,0,0,0,1,0),
		(5,0,0,0,0,1)
SELECT * FROM RightHand WHERE ID=3

use master;