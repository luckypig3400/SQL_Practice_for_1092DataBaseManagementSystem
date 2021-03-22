if db_id('practiceDB') is not null begin
	drop database practiceDB;
end
create database practiceDB;

use practiceDB;