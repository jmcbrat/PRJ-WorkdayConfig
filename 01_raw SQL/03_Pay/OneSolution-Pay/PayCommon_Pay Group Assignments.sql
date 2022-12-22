--PayCommon_Pay Group Assignments
SELECT 
	hr_empmstr.id as 'R-EmployeeID'
	,'OneSolution' AS 'O-SourceSystem'
	,'01/01/2022 - Need DETAILS'  as 'O-EffectiveDate'
	,CASE 
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'Monthly' -- Retiree
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_empmstr.type = 'EO' THEN 'Elected' -- Elected 
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_emppay.PAYCLASS = '008' THEN 'Executive' -- Exec
		WHEN hr_empmstr.entity_id = 'ROOT' and hr_empmstr.id = 'E018194' THEN 'Executive' -- Exec
		ELSE 'Bi-weekly' -- rest of roots
		END AS 'R-PayGroupID'
FROM [production_finance].[dbo].[hr_empmstr]
     left join [production_finance].[dbo].[hr_emppay] 
       on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
WHERE hr_empmstr.hr_status = 'A'