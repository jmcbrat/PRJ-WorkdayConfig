/*HR_EMP_terminations*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'EMP-Terminations' as TabName
,'HR_EMP_terminations' as QueryName
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

where (hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
		AND hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
		AND hr_empmstr.termcode <> 'NVST')
	OR (hr_empmstr.ENTITY_ID IN ('PENS')
		AND hr_empmstr.hr_status = 'A')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)

where (hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
		AND hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
		AND hr_empmstr.termcode <> 'NVST')
	OR (hr_empmstr.ENTITY_ID IN ('PENS')
		AND hr_empmstr.hr_status = 'A')
/* end of grab */
) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;





SELECT
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,CASE 
  WHEN hr_empmstr.HR_STATUS = 'I' THEN replace(convert(varchar,hr_empmstr.enddt,106),' ','-')
  --WHEN hr_empmstr.HR_STATUS = 'A' THEN dateadd(day,-1,hr_empmstr.hdt)
  ELSE null
  END as 'TerminationDate'
,CASE
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is null 
  and DATEPART(dw,hr_empmstr.enddt) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_empmstr.enddt), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) = 1 THEN replace(convert(varchar, dateadd(day,-2,hr_empmstr.lastdaywrk), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) between 3 and 7 THEN replace(convert(varchar, dateadd(day,-1,hr_empmstr.lastdaywrk), 106),' ','-')
WHEN hr_empmstr.lastdaywrk is NOT null 
  and DATEPART(dw,hr_empmstr.lastdaywrk) = 2 THEN replace(convert(varchar, dateadd(day,-3,hr_empmstr.lastdaywrk), 106),' ','-')
ELSE ''
END  as 'LastDayofWork'
,CASE 
	WHEN hr_empmstr.termcode = 'DFRC' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'DFRT' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode = 'DISC' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'NOTR' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'NVST' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'RDIS' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'RESN' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode = 'RETR' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'REXP' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'RIF' THEN 'Terminate_Employee_Involuntary_Reduction_in_Force'
	WHEN hr_empmstr.termcode = 'RTDF' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode = 'SUME' THEN 'Terminate_Employee_Involuntary_Contract_Ended'
	WHEN hr_empmstr.termcode = 'TERM' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = 'TRNS' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode = '10YR' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DFRF' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DFRT' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode = 'PAID' THEN 'Terminate_Employee_Voluntary_Compensation'
	ELSE ''
	END as 'PrimaryReason'
,CASE 
	WHEN hr_empmstr.termcode2 = 'DFRC' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'DFRT' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode2 = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode2 = 'DISC' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'NOTR' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'NVST' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'RDIS' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'RESN' THEN 'Terminate_Employee_Voluntary_Personal_Reasons'
	WHEN hr_empmstr.termcode2 = 'RETR' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'REXP' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'RIF' THEN 'Terminate_Employee_Involuntary_Reduction_in_Force'
	WHEN hr_empmstr.termcode2 = 'RTDF' THEN 'Terminate_Employee_Voluntary_Retirement'
	WHEN hr_empmstr.termcode2 = 'SUME' THEN 'Terminate_Employee_Involuntary_Contract_Ended'
	WHEN hr_empmstr.termcode2 = 'TERM' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = 'TRNS' THEN 'Terminate_Employee_Involuntary_Conversion'
	WHEN hr_empmstr.termcode2 = '10YR' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DFRF' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DFRT' THEN 'Terminate_Employee_Voluntary_Compensation'
	WHEN hr_empmstr.termcode2 = 'DIED' THEN 'Terminate_Employee_Voluntary_Death'
	WHEN hr_empmstr.termcode2 = 'PAID' THEN 'Terminate_Employee_Voluntary_Compensation'
	ELSE ''
	END  as 'SecondaryReason'
,'' as 'LocalTerminationReason'
,'' as 'PayThroughDate'
,'' as 'ResignationDate'
,'' as 'NotifyEmployeeByDate'
,'' as 'Regrettable'
,'' as 'EligibleforRehire'

from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  		 and hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)

where (hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
		AND hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
		AND hr_empmstr.termcode <> 'NVST')
	OR (hr_empmstr.ENTITY_ID IN ('PENS')
		AND hr_empmstr.hr_status = 'A')
order by 1
