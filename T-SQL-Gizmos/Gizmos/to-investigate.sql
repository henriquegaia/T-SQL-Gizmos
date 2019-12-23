--to-investigate

DECLARE @myVariable AS varchar(3) = N'abc';
DECLARE @myNextVariable AS char(3) = N'abc';
--The following returns 1
SELECT DATALENGTH(@myVariable), DATALENGTH(@myNextVariable);
SELECT LEN(@myVariable), LEN(@myNextVariable);
GO
--------------------------------------------------------------------------------