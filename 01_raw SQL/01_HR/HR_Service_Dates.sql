/*service dates */
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Service Dates' as TabName
,'service dates' as QueryName
,ISNULL(ROOTCnt,0) as ROOTCNT
,ISNULL(RoadCNT,0) as ROADCNT
,ISNULL(PENSCnt,0) as PENSCNT
,ISNULL(ZINSCNT,0) as ZINSCNT
,ISNULL(ROOTRet,0) as ROOTRet
,ISNULL(ROADRet,0) as ROADRet
,ISNULL(PENSRet,0) as PENSRet
,ISNULL(TotalRecords,0) as TotalRecords
FROM (
select 
IIF(hr_empmstr.hr_Status = 'I',hr_empmstr.Entity_id+'RET',hr_empmstr.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
where hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in('ROOT','PENS','ROAD')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
where hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in('ROOT','PENS','ROAD')
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



SELECT 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,replace(convert(varchar, hr_empmstr.beg, 106),' ','-') as 'OriginalHireDate'
,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-') as 'ContinuousServiceDate'
,'' as 'ExpectedRetirementDate'
,'' as 'RetirementEligibilityDate'
,'' as 'SeniorityDate'
,'' as 'SeveranceDate'
,'' as 'BenefitsServiceDate'
,'' as 'CompanyServiceDate'
,CASE /*need to validate this is correct */ 
  WHEN hr_empmstr.entity_id IN ('ROOT','ROAD') THEN replace(convert(varchar,hr_empmstr.hrdate2,106),' ','-')
  WHEN hr_empmstr.entity_id = 'PENS' THEN ''
  ELSE ''
END AS 'TimeOffServiceDate'
,'' as 'VestingDate'


/*,'+++++hr_emppay+++++'
,hr_emppay.*
*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
where hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID in('ROOT','PENS','ROAD')
  /*and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
order by 1