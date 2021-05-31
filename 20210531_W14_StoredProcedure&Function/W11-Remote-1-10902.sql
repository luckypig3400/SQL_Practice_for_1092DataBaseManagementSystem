-- 切換資料庫
USE 練習14
GO 
-- 新增Stored Procedure
------------規則-------------
-- CREATE PROCEDURE {預存程序名稱}
-- AS
-- {程式碼}

-- P14-9a
CREATE PROCEDURE MyProc1
AS
SELECT * FROM 標標公司 WHERE 價格 > 400
GO 

-- 執行SP
EXEC MyProc1

GO 
------------規則(引數規則)-------------
-- CREATE PROCEDURE {預存程序名稱}
-- @param1 {資料型態}, @param2 {資料型態}
-- {選項}
-- AS
-- {程式碼}

-- {選項}--
-- RECOMPILE : 執行時會重新編譯一次
-- ENCRYPTION : 將SP封裝，看不到程式碼

-- P14-9b
CREATE PROCEDURE MyProc2 
@param1 char(10), @param2 money 
WITH ENCRYPTION 
AS INSERT 標標公司 (產品名稱, 價格) 
     VALUES (@param1, @param2) 
GO 

-- 執行SP 帶入輸入引數
EXEC MyProc2 '組合語言', 520
GO
SELECT * FROM 標標公司 
GO 

-- P14-10
-- 執行SP 帶入輸入引數 以及 輸出(Output)
CREATE PROCEDURE MyProc3 
@param1 char(10), @param2 money, @param3 money OUTPUT 
AS INSERT 標標公司 (產品名稱, 價格) 
     VALUES (@param1, @param2) 
     SELECT @param3 = SUM(價格)
     FROM 標標公司 
GO 

CREATE PROCEDURE MyProc4
@param1 money 
AS PRINT '目前的總價為: ' + CONVERT(varchar, @param1) 
GO 

-- 執行，顯示回傳輸出結果，使用宣告變數作為接收SP輸出值
DECLARE @sum money
EXEC MyProc3 'MATHLAB 手冊',320,@sum OUTPUT

PRINT @sum

EXEC MyProc4 @sum 

GO 

-- P14-11a
-- 加入回傳(RETURN)
-- Note: SP裡面查詢結果為單筆跟多筆的差異
CREATE PROCEDURE 取得客戶地址 
@客戶編號 int, 
@地址 varchar(100) OUTPUT 
AS SELECT @地址 = 地址 
     FROM 客戶 
	 ORDER BY 客戶編號 DESC
     WHERE 客戶編號 = @客戶編號 
IF @@rowcount > 0 
     RETURN 0   /* 如果查詢到則傳回 0 */ 
ELSE 
     RETURN 1   /* 沒有查到就傳回 1 */ 
GO 
-- DROP PROCEDURE 取得客戶地址
-- SELECT * FROM 客戶

DECLARE @ret int, @地址 varchar(100) 
EXEC @ret = 取得客戶地址 4, @地址 OUTPUT  /* 用 @ret 接收傳回值 */ 
IF @ret = 0 
     PRINT @地址 
ELSE 
     PRINT '找不到！' 

GO 


-- SP群組程序
-- P14-11b
/* 建立 MyProc5 預存程序群組的第 1 個程序 */ 
CREATE PROCEDURE MyProc5;1 
AS SELECT * 
     FROM 旗旗公司 
GO

/* 建立 MyProc5 預存程序群組的第 2 個程序 */ 
CREATE PROCEDURE MyProc5;2 
AS 
SELECT * 
     FROM 標標公司 
GO 
MyProc5;1
EXEC MyProc5;2

GO 

-- P14-14

CREATE PROCEDURE MyProc6 
AS SELECT 產品名稱, 價格
     FROM 標標公司
     WHERE 產品名稱 LIKE '%SQL%'

GO 

-- 修改(更新)預存程序
-- 注意權限
-- P14-16
ALTER PROCEDURE MyProc2
AS SELECT * 
   FROM 標標公司 

GO 

-- 可加入引數預設值，當有預設值時，執行可不需要輸入引數，但順序要正確
-- P14-21
CREATE PROCEDURE test 
@a int, 
@b int = NULL, 
@c int = 3 
AS 
SELECT @a, @b, @c 
GO 

EXEC test     /* 錯誤, 第一個參數不可省 */ 
GO 
EXEC test 1  /* OK, 第 2、3 參數用預設值 */ 
GO 
EXEC test 1, DEFAULT      /* OK, 可用 DEFAULT 表示使用預設值 */ 
GO
EXEC test 1, DEFAULT, 5  /* OK */ 
GO 
EXEC test 1, 2, 5                 /* OK */ 
GO 

GO 

-- 可輸入引數，可使用DEFULALT表示使用SP內建的預設值
-- P14-22a
EXEC test @c = 5, @b = DEFAULT, @a = 1

GO 

-- P14-22b
EXEC test 1, @c = 2
GO
EXEC test @c = 2, 1
GO
EXEC test @c = 5
GO 


-- P14-23
CREATE PROCEDURE TestRetVal 
@TableName varchar(30) OUTPUT 
AS 
DECLARE @sqlstr varchar(100) 
SET @sqlstr = 'SELECT * FROM ' + @TableName 
--EXEC (@sqlstr)     /* 執行字串中的 SQL 敘述 */ 
SELECT * FROM 旗旗公司
IF @@ERROR = 0 
     BEGIN 
          SET @TableName = 'Hello' 
          RETURN 0 
     END 
ELSE 
     RETURN 1
GO
 
DECLARE @ret int, @name varchar(30) 
SET @name = '旗旗公司' 
EXEC @ret = TestRetVal @name OUTPUT 
SELECT @name + ', RETURN = ' + CAST(@ret AS CHAR) 

--- NOTE:切換顯示結果視窗 - 以文字方式顯示
GO 

-- P14-24
CREATE PROCEDURE testWithResultSet     -- 建立預存程序
AS SELECT * FROM 旗旗公司
GO

EXEC testWithResultSet

-- 自訂SP回傳資料格式
-- 語法: 
-- EXEC
-- WITH RESULT SETS

EXEC testWithResultSet
WITH RESULT SETS
( (產品 nvarchar(20), 
   價格 int)
)

GO 

-- P14-26
CREATE PROCEDURE testWithResultSet2     -- 建立預存程序
AS 
SELECT * FROM 旗旗公司
SELECT * FROM 標標公司
GO

EXEC testWithResultSet2
WITH RESULT SETS
( (旗旗產品 nvarchar(20), 價格 int),
  (標標產品 nvarchar(20), 價格 int)
)

GO 


-- SP呼叫SP --nested call
-- P14-29b
CREATE PROCEDURE proc3 
AS PRINT 'Proc3: at level ' + CAST(@@NESTLEVEL AS CHAR) 
GO 
CREATE PROCEDURE proc2 
AS PRINT 'Proc2 start: at level ' + CAST(@@NESTLEVEL AS CHAR) 
EXEC proc3 
PRINT 'Proc2 end: at level ' + CAST(@@NESTLEVEL AS CHAR) 
GO 
CREATE PROCEDURE proc1 
AS PRINT 'Proc1 start: at level ' + CAST(@@NESTLEVEL AS CHAR) 
EXEC proc2 
PRINT 'Proc1 end: at level ' + CAST(@@NESTLEVEL AS CHAR) 
GO 

EXEC proc1 
-- NOTE:　SP Recursive call
GO 

-- 使用TABLE型別作為引數
-- P14-33
CREATE TYPE IntTableType AS TABLE 
(名稱 VARCHAR(20), 數值 INT )
GO

CREATE PROC 找出最大者
@title varchar(30), 
@tab IntTableType READONLY
AS
DECLARE @maxv INT
SELECT @maxv = MAX(數值) FROM @tab

SELECT @title 說明, 名稱 最大者, @maxv 數量
FROM @tab
WHERE 數值 = @maxv
GO

-- P14-34
DECLARE @tab IntTableType
INSERT @tab
SELECT 客戶名稱, sum(數量)
FROM 出貨記錄
GROUP BY 客戶名稱

EXEC 找出最大者 '出貨量最大的客戶', @tab

--DELETE @tab

DECLARE @tab IntTableType
INSERT @tab
SELECT 股票名稱, sum(購買張數)
FROM 股票交易記錄
GROUP BY 股票名稱

EXEC 找出最大者 '庫存最多的股票', @tab
GO