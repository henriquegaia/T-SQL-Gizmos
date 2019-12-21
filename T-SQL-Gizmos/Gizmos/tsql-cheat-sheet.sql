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
--------------------------------------------------------------------------------
-- Number of 8K Pages Used by a Table and/or Database
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