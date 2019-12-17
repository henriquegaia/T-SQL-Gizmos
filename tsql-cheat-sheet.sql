use Foo;
--------------------------------------------------------------------------------
-- For every single index on an object get seeks, scans, lookups and update

declare @obj nvarchar(20) = N'Users';

select 
	o.name as table_name, i.name as index_name,
	s.user_seeks, s.user_scans, s.user_lookups, s.user_updates
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
