if db_id('practiceDB') is not null begin
	drop database practiceDB;
end
create database practiceDB;

use practiceDB;

--1. ������Ʈw
use master;--�������L��Ʈw���A����
EXEC sp_detach_db practiceDB;

