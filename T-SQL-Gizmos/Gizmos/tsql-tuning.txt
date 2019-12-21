/*
BE CREEPY

from: https://www.brentozar.com/sql/watch-brent-tune-queries/

BE CREEPY stands for:

    Blitz first for obvious problems – use sp_Blitz® looking for SQL Server settings that are causing overall slowness. Use sp_BlitzIndex® looking for heaps, disabled indexes, missing indexes.
    End user requirements gathering – define your finish line, when end users will let you quit tuning this query and go on to something else. Get the business purpose of the query output. Can we run it less often, or run it somewhere else?
    Capture query metrics – run the query with SET STATISTICS IO ON, and gather the actual execution plan. Make sure you’ve got the right query and the right plan by double-checking it against the plan cache. Start a separate SSMS window to compare it before and after.
    Read the query – now that you have the actual metrics, read through the query to see if you can notice common anti-patterns that might be causing the query’s bad metrics, like high CPU, high reads, or high memory grants.
    Experiment with the query cost – try various quick fixes to remove common T-SQL anti-patterns. Remove the ORDER BY, remove the list of fields in the SELECT, switch from table variables to temp tables, check the join types, etc. If these easy fixes take you across the finish line, start asking tough questions about what we’re doing in the query.
    Execution plan review – look at the plan’s properties for Optimization Level and the Reason for Early Termination. Look at the top right operator in the plan – are there implicit conversion or SARGability problems? Are the estimated versus actual row counts way off? Fix these, and scan through the rest of the plan looking for these problems.
    Parallelism opportunities – is the query going parallel, and if so, is it helping? If it’s not, can we go parallel and go faster? Check for parallelism inhibitors in the query.
    Index opportunities – yes, technically this is an i instead of a y, but hey, nobody’s perfect. This is last – we don’t want to rapidly change the database to match our query. Indexes are a later resort for individual query tuning, not the first.
*/
