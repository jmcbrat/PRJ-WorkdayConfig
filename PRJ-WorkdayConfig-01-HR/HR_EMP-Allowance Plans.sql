--HR_EMP-Allowance Plans
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Compensation_Template_Calculate Plan tab_Mapped.xlsx' as Spreadsheet
,'EMP-Allowance Plans' as TabName
,'HR_EMP-Allowance Plans' as QueryName
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
     RIGHT join [production_finance].[dbo].[hr_cdhassgn] 
     on hr_empmstr.id = hr_cdhassgn.id 
	  and hr_cdhassgn.no in ('3189','3300','3320','3321','3222','3323')
     --and hr_cdhassgn.ENDDT = '12/31/2050'
where 
 hr_empmstr.ENTITY_ID in ('ROOT')
 AND ((hr_empmstr.hr_status ='A' and hr_cdhassgn.ENDDT = '12/31/2050')
   OR (hr_empmstr.hr_status ='I' and hr_empmstr.enddt >'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
     RIGHT join [production_finance].[dbo].[hr_cdhassgn] 
     on hr_empmstr.id = hr_cdhassgn.id 
	  and hr_cdhassgn.no in ('3189','3300','3320','3321','3222','3323')
     --and hr_cdhassgn.ENDDT = '12/31/2050'
where 
 hr_empmstr.ENTITY_ID in ('ROOT')
 AND ((hr_empmstr.hr_status ='A' and hr_cdhassgn.ENDDT = '12/31/2050')
   OR (hr_empmstr.hr_status ='I' and hr_empmstr.enddt >'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;





SELECT /*hr_cdhassgn.ENDDT,*/
trim(hr_empmstr.id) as 'EmployeeID'
,hr_empmstr.hr_status
,hr_empmstr.enddt
,hr_cdhassgn.ENDDT
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'Sequence#'
,'Request_Compensation_Change_Conversion_Conversion' as 'CompensationChangeReason'
,'' as 'PositionID'

,IIF(hr_cdhassgn.beg = '1/1/1960'
  ,replace(convert(varchar,hr_empmstr.hdt,106),' ','-')
  ,replace(convert(varchar,hr_cdhassgn.beg,106),' ','-')) as 'EffectiveDate'
,CASE
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3189' THEN 'STIPEND'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3300' THEN 'CAR ALLOWANCE'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3320' THEN 'EA-ASSOCIATES'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3321' THEN 'EA-BACHELORS'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3322' THEN 'EA-CERTIFICATE'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3323' THEN 'EA-MASTERS'
  ELSE convert(varchar,hr_cdhassgn.no)
END as 'AllowancePlan#1'
,'' as 'Percent-AllowancePlan#1'
,'' as 'Amount-AllowancePlan#1'
,'' as 'CurrencyCode-AllowancePlan#1'
,'' as 'Frequency-AllowancePlan#1'
,'' as 'ExpectedEndDate-AllowancePlan#1'
,'' as 'ReimbursementStartDate-AllowancePlan#1'
,CASE
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3189' THEN 'STIPEND'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3330' THEN 'CAR ALLOWANCE'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3320' THEN 'EA-ASSOCIATES'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3321' THEN 'EA-BACHELORS'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3322' THEN 'EA-CERTIFICATE'
  WHEN hr_empmstr.entity_id = 'ROOT' and hr_cdhassgn.no = '3323' THEN 'EA-MASTERS'
  ELSE ''
END as 'AllowancePlan#2'
,'' as 'Percent-AllowancePlan#2'
,'' as 'Amount-AllowancePlan#2'
,'' as 'CurrencyCode-AllowancePlan#2'
,'' as 'Frequency-AllowancePlan#2'
,'' as 'ExpectedEndDate-AllowancePlan#2'
,'' as 'ReimbursementStartDate-AllowancePlan#2'
,'' as 'AllowancePlan#3'
,'' as 'Percent-AllowancePlan#3'
,'' as 'Amount-AllowancePlan#3'
,'' as 'CurrencyCode-AllowancePlan#3'
,'' as 'Frequency-AllowancePlan#3'
,'' as 'ExpectedEndDate-AllowancePlan#3'
,'' as 'ReimbursementStartDate-AllowancePlan#3'
,'' as 'AllowancePlan#4'
,'' as 'Percent-AllowancePlan#4'
,'' as 'Amount-AllowancePlan#4'
,'' as 'CurrencyCode-AllowancePlan#4'
,'' as 'Frequency-AllowancePlan#4'
,'' as 'ExpectedEndDate-AllowancePlan#4'
,'' as 'ReimbursementStartDate-AllowancePlan#4'
from [production_finance].[dbo].[hr_empmstr]
     RIGHT join [production_finance].[dbo].[hr_cdhassgn] 
     on hr_empmstr.id = hr_cdhassgn.id 
	  and hr_cdhassgn.no in ('3189','3300','3320','3321','3222','3323')
     --and hr_cdhassgn.ENDDT = '12/31/2050'
where 
 hr_empmstr.ENTITY_ID in ('ROOT')
 AND ((hr_empmstr.hr_status ='A' and hr_cdhassgn.ENDDT = '12/31/2050')
   OR (hr_empmstr.hr_status ='I' and hr_empmstr.enddt >'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
 order by 1