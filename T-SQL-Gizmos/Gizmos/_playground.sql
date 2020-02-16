--playground

use foo
--set statistics io on
--set statistics time on

--exec sp_blitzcache 
--	  @databaseName = 'foo'
--	--, @SortOrder = 'recent compilations'
--	-- reads, cpu, duration, executions,xpm, memory grant, recent compilations
--	--, @Top = 3
--	--, @expertMode = 1
--	--, exportToExcel = 1
--	, @outputDatabaseName = 'Foo'
--	, @outputSchemaName = 'dbo'
--	, @outputTableName = 'BlitzCacheResults'
--	--@help = 1

--exec sp_BlitzIndex 
	--@GetAllDatabases = 1
	--@mode = 4
	--@bringThePain = 1
	--@help = 1

--use AdventureWorks2016
--exec sp_BlitzFirst
--	--@expertMode= 1
--	@sinceStartUp = 1
--------------------------------------------------------------------------------
/*
--deadlock tests
DBCC TRACEON (1222,-1)
DBCC TRACESTATUS (1222)

DBCC TRACEOFF (1222,-1)
DBCC TRACESTATUS (1222)

SELECT * FROM SYS.DATABASES

use foo 

begin tran
update users set Name = 'a' where id = 1
commit tran

begin tran
update users2 set Name = 'a' where id = 1
commit tran

select * from users where id =1
select * from users2 where id =1
*/
use foo
--session 1

--begin tran trx
--	update users 
--	set datelog='20170102'
--	where id = 333
	
--commit tran trx

--session 2
select datelog from users where id = 333

exec dbo.sp_WhoIsActive @get_locks = 1
