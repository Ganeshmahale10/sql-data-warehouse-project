USE master;
Go

--Creating the new database

create database DataWarehouse;
Go

use Datawarehouse;
Go

--Creating the schemas

CREATE SCHEMA bronze;
Go

CREATE SCHEMA silver;
Go

CREATE SCHEMA gold;
Go


--select * from sys.databases
