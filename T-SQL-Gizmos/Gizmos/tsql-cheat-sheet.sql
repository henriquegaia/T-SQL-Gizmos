use Foo;
--------------------------------------------------------------------------------
-- For every single index on an object get seeks, scans, lookups and update
--------------------------------------------------------------------------------
declare @obj nvarchar(20) = N'Users';

select 
	o.name as table_name, i.name as index_name,
	s.user_seeks, s.user_scans, s.user_lookups, s.user_updates,
	i.is_disabled
from	
	sys.dm_db_index_usage_stats s
inner join
	sys.indexes i on i.index_id = s.index_id
inner join
	sys.objects o on o.object_id = s.object_id
inner join
	sys.schemas c on c.schema_id = o.schema_id
where 
	o.name = @obj
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
select
	s.name + '.' + o.name 'TableName'
	,i.type_desc
	,o.type_desc
	,o.create_date
from 
	sys.indexes i
join 
	sys.objects o on i.object_id = o.object_id
join 
	sys.schemas s on s.schema_id = o.schema_id
where 
	o.type_desc = 'USER_TABLE' and
	i.type_desc = 'HEAP'
order by 
	o.name
--------------------------------------------------------------------------------
-- Tables without clustered index
--------------------------------------------------------------------------------
select 
	*
from 
	information_schema.tables
where 
	objectproperty(object_id(table_name), 'TableHasClustIndex') = 0
--------------------------------------------------------------------------------
-- Amount of tables per DB
--------------------------------------------------------------------------------
exec sp_MSforeachdb 'use [?] 
	select   
		''?'' as DatabaseName,
		COUNT(o.name) as Count 
	from 
		sys.indexes i
	inner join 
		sys.objects o on i.object_id = o.object_id
	where 
		o.type_desc = ''USER_TABLE'' and
		i.type_desc = ''HEAP'''
--------------------------------------------------------------------------------
-- Number of 8K Pages Used by a Table and/or Database
--------------------------------------------------------------------------------
select 
    t.name as Tablename,
    p.rows as RowCounts,
    sum(a.total_pages) as TotalPages, 
    sum(a.used_pages) as UsedPages, 
    (sum(a.total_pages) - sum(a.used_pages)) as UnusedPages
from 
    sys.tables t
inner join      
    sys.indexes i on t.object_id = i.object_id
inner join 
    sys.partitions p on i.object_id = p.object_id and i.index_id = p.index_id
inner join 
    sys.allocation_units a on p.partition_id = a.container_id
where 
    t.name not like 'dt%' 
    and t.is_ms_shipped = 0
    and i.object_id > 255 
group by 
    t.name, p.rows
order by 
    t.name
go
--------------------------------------------------------------------------------
-- Which queries are running long and where you might be experiencing blocking
-- v1
--------------------------------------------------------------------------------	
select  
	*
from    
	sys.dm_exec_requests as der
cross apply 
	sys.dm_exec_sql_text(der.sql_handle) as dest
cross apply 
	sys.dm_exec_query_plan(der.plan_handle) as deqp;
go
--------------------------------------------------------------------------------
-- Which queries are running long and where you might be experiencing blocking
-- v2
--------------------------------------------------------------------------------
select  substring(dest.text, ( der.statement_start_offset / 2 ) + 1,
                  ( case der.statement_end_offset
                      when -1 then datalength(dest.text)
                      else der.statement_end_offset
                           - der.statement_start_offset
                    end ) / 2 + 1) as querystatement ,
        deqp.query_plan ,
        der.session_id ,
        der.start_time ,
        der.status ,
        db_name(der.database_id) as dbname ,
        user_name(der.user_id) as username ,
        der.blocking_session_id ,
        der.wait_type ,
        der.wait_time ,
        der.wait_resource ,
        der.last_wait_type ,
        der.cpu_time ,
        der.total_elapsed_time ,
        der.reads ,
        der.writes
from    sys.dm_exec_requests as der
        cross apply sys.dm_exec_sql_text(der.sql_handle) as dest
        cross apply sys.dm_exec_query_plan(der.plan_handle) as deqp;
go
--------------------------------------------------------------------------------
-- Which queries are running long and where you might be experiencing blocking
-- v2
--------------------------------------------------------------------------------
select	job_id,last_executed_step_id
from	msdb.dbo.sysjobactivity
where	last_executed_step_id is not null
 --------------------------------------------------------------------------------
-- Identify Collation for a SQL Server database
--------------------------------------------------------------------------------
declare @databasename as sysname
set		@databasename = 'adventureworks2016'
select	db_name(db_id(@databasename)) as databasename
		,databasepropertyex(@databasename, 'collation') as collationusedbysqlserverdatabase
go
--------------------------------------------------------------------------------
-- Collation used by all the databases on a SQL Server instance 
--------------------------------------------------------------------------------
use		master
go
select	name, 
		collation_name
from	sys.databases
order by database_id asc
go
--------------------------------------------------------------------------------
-- Identify SQL Server Collation Settings
--------------------------------------------------------------------------------
use		master
go
select	serverproperty('collation') as sqlservercollation
go
--------------------------------------------------------------------------------
-- Forcing a lock 
--------------------------------------------------------------------------------
-- session 1

begin tran
	update	users	with(tablock) -- or tablockx
	set		datelog ='20171111'
	where	id=1 
	waitfor delay '00:02:00'
rollback tran 
go
-- session 2
update	users
set		datelog='20171112'
where	id=1 
-- on any session, check xml on field 'locks'
exec sp_WhoIsActive 
	@get_locks = 1
--------------------------------------------------------------------------------
-- Ordering first by non null values, and then by null values
--------------------------------------------------------------------------------
select		id, [name] 
from		users 
order by	case 
				when [name] is null then 1
				else 0
			end, [name]

