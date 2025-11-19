drop table if exists #TableCounts
-- Step 1: Create a temp table to hold results
CREATE TABLE #TableCounts (
server_name NVARCHAR(256),
    TableName NVARCHAR(256),
    CNT INT
);

-- Step 2: Declare a variable to hold dynamic SQL
DECLARE @SQL NVARCHAR(MAX) = N'';

-- Step 3: Build the dynamic SQL to insert into temp table
SELECT @SQL += 
    'INSERT INTO #TableCounts (server_name,TableName, CNT) 
     SELECT ''TPAPWSQLDL006'' as server_name,''' + TABLE_SCHEMA + '.' + TABLE_NAME + ''', COUNT(*) 
     FROM [' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] WITH (NOLOCK);'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Step 4: Execute the dynamic SQL
--print @SQL
 EXEC sp_executesql @SQL;

-- Optional: Drop the temp table if no longer needed
-- DROP TABLE #TableCounts;


select @SQL = ''

DECLARE @SQL NVARCHAR(MAX) = N'';
SELECT @SQL += 
    'INSERT INTO #TableCounts (server_name,TableName, CNT) 
     SELECT ''TPAPWSQLDL001'' as server_name,''' + TABLE_SCHEMA + '.' + TABLE_NAME + ''', COUNT(*) 
     FROM TPAPWSQLDL001.HPS_EPS.[' + TABLE_SCHEMA + '].[' + TABLE_NAME + '] WITH (NOLOCK);'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

print @SQL
EXEC sp_executesql @SQL;



select * from #TableCounts



drop table if exists #ttt2
SELECT s.*,t.cnt as cnt_2, s.cnt-t.cnt as diff into #ttt2 FROM #TableCounts s
inner join #TableCounts t on s.TableName = t.TableName
where s.server_name = 'TPAPWSQLDL001' and t.server_name ='TPAPWSQLDL006'
order by diff desc


select * from #ttt2
where diff != 0
order by diff desc
