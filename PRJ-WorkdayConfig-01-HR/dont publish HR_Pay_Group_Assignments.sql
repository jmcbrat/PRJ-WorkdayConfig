/*HR Pay Group Assignments*/
SELECT
trim(hr_empmstr.id) as 'R-EmployeeID'
,'Denise Krzeminski' as 'O-SourceSystem'
,'' as 'O-EffectiveDate'
,'Default_Pay_Group' as 'R-PayGroupID'
from [IT.Macomb_dba].[dbo].[xref_hr_empmster__x__contact] x
     left join [production_finance].[dbo].[hr_empmstr]
	  on x.id = hr_empmstr.id
     left join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
where hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
 and hr_empmstr.hr_status = 'A'--*/
/* and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) --*/

