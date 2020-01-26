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

use AdventureWorks2016
exec sp_BlitzFirst
	--@expertMode= 1
	@sinceStartUp = 1
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
begin tran
update users 
set datelog='20170102'
where year(datelog)=2019
--commit tran

--session 2
select * from users 
where year(datelog)=2019

use foo
exec dbo.sp_WhoIsActive @get_locks = 1
/*
<Database name="Foo">
  <Locks>
    <Lock request_mode="S" request_status="GRANT" request_count="1" />
  </Locks>
  <Objects>
    <Object name="Users" schema_name="dbo">
      <Locks>
        <Lock resource_type="KEY" index_name="IX_DateLog_Id"				request_mode="X" request_status="GRANT" request_count="1192" />
        <Lock resource_type="KEY" index_name="IX_DateLog_Id_Name"			request_mode="X" request_status="GRANT" request_count="1192" />
        <Lock resource_type="KEY" index_name="PK__Users__A2B5777C4DAFCFAB"	request_mode="X" request_status="GRANT" request_count="596" />
        <Lock resource_type="OBJECT" request_mode="IX" request_status="GRANT" request_count="1" />
        <Lock resource_type="PAGE" page_type="*" index_name="IX_DateLog_Id"					request_mode="IX" request_status="GRANT" request_count="8" />
        <Lock resource_type="PAGE" page_type="*" index_name="IX_DateLog_Id_Name"			request_mode="IX" request_status="GRANT" request_count="9" />
        <Lock resource_type="PAGE" page_type="*" index_name="PK__Users__A2B5777C4DAFCFAB"	request_mode="IX" request_status="GRANT" request_count="5" />
      </Locks>
    </Object>
  </Objects>
</Database>
*/

