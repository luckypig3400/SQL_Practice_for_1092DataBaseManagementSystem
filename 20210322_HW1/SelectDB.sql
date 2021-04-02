/*
問題3 - 新增資料表與更新關聯 (合計共110分)
以SELECT語法查詢經過CreateDB.sql以及AlterDB.sql執行後的資料庫，，規則說明如下
3. SelectDB.sql: 規格:
 - 3.1 使用SELECT查詢語法進行跨資料表查詢，並顯示以下欄位 
 (1) "姓氏 + 名字" (姓與名中間要1個空白), (2) 生日與性別, 
 (3)城市, 國籍 (4)帳號 (5) 分行名稱 (6) 餘額。
 其中(1), (2), (3)顯示結果,兩個欄位數值中間需要有一個','符號等
 作為區隔需分兩欄位的數值 (1:15分、2-3: 10分，4-6:  5分，
 合計: 15x1 + 10x3 + 5x3=50分)
*/
use BANK;
select C.LName + ', ' + C.FName as 姓名,cast(C.BDate as varchar(15)) +', Sex:'+ C.Sex as 生日與性別,
C.City +', '+ C.Country as 城市與國籍, A.AccID as 帳號, B.BranchBankName as 分行名稱, A.Balance as 餘額
from Account as A, BankBranch as B, Customer as C 
where C.ID = A.ID and A.BranchID = B.BranchID;



/*
 - 3.2 使用SELECT語法查詢所有使用者帳號一共交易的次數，並將結果以
 (1) "姓氏 + 名字", (2) 交易次數的結果顯示出來 
 (1:20分, 2:20分, 執行結果正確性: 20分，合計: 60分)
*/




use master;--release database BANK