if db_id('practiceDB') is not null begin
	drop database practiceDB;
end
create database practiceDB;

use practiceDB;

--1. 卸離資料庫
use master;--切換到其他資料庫中再執行
EXEC sp_detach_db practiceDB;

