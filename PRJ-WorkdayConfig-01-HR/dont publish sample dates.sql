select DFLT_HRS
,PCN -- skip first 2, use next 5, skip last 3

,hr_emppay.*
from [production_finance].[dbo].[hr_emppay] 
where hr_emppay.id ='E020533'
and pay_beg  <=getdate()
and pay_end >=getdate()
order by pay_beg 

--actl_hrs