drop table #ss
select *, convert(varchar(4000),design_default_value)design_default_value_1, convert(varchar(4000),default_value) default_value_1 into #ss
from [internal].[object_parameters] where design_default_value  is not null
 
drop table #pp
 
select * into #pp from #ss where design_default_value_1  like '%TPASWSQLDL001%'  or default_value_1 like '%TPASWSQLDL001%'
 
select * from #pp
 
 update #pp set design_default_value_1 = replace(design_default_value_1, 'TPASWSQLDL001', 'TPADWSQLDL001')  where design_default_value_1  like '%TPASWSQLDL001%'
 update #pp set default_value_1 = replace(default_value_1, 'TPASWSQLDL001', 'TPADWSQLDL001')  where default_value_1  like '%TPASWSQLDL001%'

 

 
select * from #pp
 
update a set a.default_value = default_value_1, a.design_default_value = p.design_default_value_1 from [internal].[object_parameters] a
inner join #pp p on a.parameter_id = p.parameter_id