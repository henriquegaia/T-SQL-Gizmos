use Foo;
--------------------------------------------------------------------------------
-- For every single index on an object get seeks, scans, lookups and update

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
select 
	*
from 
	information_schema.tables
where 
	objectproperty(object_id(table_name), 'TableHasClustIndex') = 0
--------------------------------------------------------------------------------
-- Amount of tables per DB
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

