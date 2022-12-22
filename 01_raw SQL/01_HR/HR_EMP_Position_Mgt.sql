/*EMP-Position Mgt*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT '01-JOE-FINAL-UPLOAD-SUP-ORG_08-08-2022' as Spreadsheet
,'EMP-Position Mgt' as TabName
,'EMP-Position Mgt' as QueryName
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
	  AND hr_emppay.pay_beg = (select max(hp.pay_beg) from [production_finance].[dbo].[hr_emppay] hp where hr_empmstr.id = hp.id)
	  RIGHT join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  on hr_empmstr.id = EMP_Position_Mgt.emp_id 

where hr_empmstr.hr_status = 'A'--*/
  and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  AND hr_emppay.pay_beg = (select max(hp.pay_beg) from [production_finance].[dbo].[hr_emppay] hp where hr_empmstr.id = hp.id)
	  RIGHT join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  on hr_empmstr.id = EMP_Position_Mgt.emp_id 

where hr_empmstr.hr_status = 'A'--*/
  and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
--,trim(hr_emppay.position)+'-'+ 
--     convert(varchar,ROW_NUMBER() OVER (PARTITION BY hr_emppay.position ORDER BY hr_emppay.position)) as 'PositionID'
, EMP_Position_Mgt.Position_Number as 'PositionID'
,CASE
  WHEN hr_empmstr.type  = 'FTBU' THEN 'Regular' 
  WHEN hr_empmstr.type  = 'PTBU'THEN 'Regular'
  WHEN hr_empmstr.type  = 'EO' THEN 'Regular'
  WHEN hr_empmstr.type  = 'ROAD' THEN 'Regular'
  WHEN hr_empmstr.type  = 'TEMP' THEN 'Regular' --'Temporary'
  WHEN hr_empmstr.type  = 'SUMR' THEN 'JTP Senior'
  ELSE ''
 END as 'EmployeeType'
,'Hire_Employee_Hire_Employee_Conversion'  as 'HireReason'
,''  as 'FirstDayofWork'
,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')  as 'HireDate'
,''  as 'ProbationStartDate'
,''  as 'ProbationEndDate'
,''  as 'EndEmploymentDate'
,''  as 'PositionStartDateforConversion'
,iif(EMP_Position_Mgt.supervisory_org is null, 'SUP_UNASSIGNED',EMP_Position_Mgt.supervisory_org) as 'SupervisoryOrganizationID'
/* C&P,trim(hr_postble.LONG_DESC)  as 'R-JobPostingTitle(forthePosition)'*/
,substring(hr_emppay.indx_key,4,3)+Left(hr_emppay.indx_key,2) as 'JobPostingTitle(forthePosition)'
,substring(hr_emppay.indx_key,4,3) as 'JobCode'
,''  as 'PositionTitle'
,''  as 'BusinessTitle'
,CASE
  WHEN  hr_empmstr.department = 'FAC' THEN 'LOC001'
  WHEN  hr_empmstr.department = 'PDO' THEN 'LOC002'
  WHEN  hr_empmstr.department = 'ANC' THEN 'LOC003'
  WHEN  hr_empmstr.department IN ('CES','CSA','SCS','VET') THEN 'LOC004'
  WHEN  hr_empmstr.department = 'SHF' THEN 'LOC014'
  WHEN  hr_empmstr.department IN ('CIP','FOC','FCJ') THEN 'LOC018'
  WHEN  hr_empmstr.department IN ('CIR','DCP','PCM','PCW','RMB','CLK') THEN 'LOC019'
  WHEN  hr_empmstr.department = 'JJC' THEN 'LOC020'
  WHEN  hr_empmstr.department IN ('BOC','CCO','CEX','EQL','HCS','HRS','LIB'
        ,'MTB','PLN','PRS','RSK','TRS','RETG','RETS','RETR','RETM') THEN 'LOC023'
  WHEN  hr_empmstr.department = 'DC2' THEN 'LOC025'
  WHEN  hr_empmstr.department = 'DC1' THEN 'LOC026'
  WHEN  hr_empmstr.department = 'PRK' THEN 'LOC027'
  WHEN  hr_empmstr.department = 'HTH' THEN 'LOC028'
  WHEN  hr_empmstr.department IN ('FIN','PUR','REG') THEN 'LOC034'
  WHEN  hr_empmstr.department IN ('MIS','ROAD','COR','ESC') THEN 'LOC035'
  WHEN  hr_empmstr.department = 'PWK' THEN 'LOC045'
  WHEN  hr_empmstr.department = 'CMH' THEN 'LOC049'
  WHEN  hr_empmstr.department IN ('ETA','JTP') THEN 'LOC127'
  ELSE hr_empmstr.department
  END as 'WorkLocation'
,''  as 'WorkSpace'

,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END as 'DefaultWeeklyHours'
,CASE
 WHEN hr_empmstr.entity_id = 'ROOT' THEN  hr_emppay.[actl_hrs]*5 
 WHEN hr_empmstr.entity_id = 'ROAD' THEN  40
 ELSE 0
 END as 'ScheduledWeeklyHours'
,''  as 'PaidFTE'
,''  as 'WorkingFTE'

,CASE
  WHEN hr_empmstr.type  = 'FTBU' THEN 'Full_Time' 
  WHEN hr_empmstr.type  = 'PTBU'THEN 'Part_Time'
  WHEN hr_empmstr.type  = 'EO' THEN 'Full_Time'
  WHEN hr_empmstr.type  = 'ROAD' THEN 'Full_Time'
  WHEN hr_empmstr.type  = 'TEMP' THEN 'Part_Time'
  WHEN hr_empmstr.type  = 'SUMR' THEN 'Part_Time'
  ELSE ''
 END  as 'TimeType'
--Part time has 3 types Temp, SUMR, PTBU
/*C&P,iif(hr_emppay.re_calc='A','Salary','Hourly')  as 'R-PayRateType'*/
,CASE
  WHEN hr_empmstr.type in ('Temp','SUMR','PTBU') THEN 'Hourly'
  WHEN hr_empmstr.id = 'E005412' THEN 'Salary'
  WHEN hr_empmstr.Entity_id = 'ROAD' THEN 'Salary'
  WHEN hr_emppay.re_calc='A' THEN 'Salary'
  WHEN hr_emppay.re_calc='H' THEN 'Hourly'
  WHEN hr_empmstr.Entity_id = 'PENS' THEN 'Salary'
  ELSE hr_emppay.re_calc
  END as 'PayRateType'
-- payRateType = h=hourly, A=Salary, ( not used: d =day or p =period)
,''  as 'CompanyInsiderType'
,''  as 'WorkShift'
,''  as 'AdditionalJobClassification#1'
,''  as 'AdditionalJobClassification#2'
,''  as 'AdditionalJobClassification#3'
,''  as 'AdditionalJobClassification#4'
from [production_finance].[dbo].[hr_empmstr]
     right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id 
	  AND hr_emppay.pay_beg = (select max(hp.pay_beg) from [production_finance].[dbo].[hr_emppay] hp where hr_empmstr.id = hp.id)
	  RIGHT join [it.Macomb_DBA].[dbo].[EMP_Position_Mgt]
	  on hr_empmstr.id = EMP_Position_Mgt.emp_id 

where hr_empmstr.hr_status = 'A'--*/
  and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
  --and hr_empmstr.id = 'E002993'
  --and hr_empmstr.id in ('E021868', 'E006018','E022032')
    


/* and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) --*/
--and left(hr_empmstr.id,1) = 'E'
--and hr_empmstr.id = 'R005329'  -- hours = 0
/*and hr_emppay.position in (
'CS11H29003'
,'DC28B00005'
,'EX01X00001'
,'FO16D03001'
,'HD08B00012'
,'JT77600010'
,'MI11X00001'
,'MI22D00001'
,'MI22D00001'
,'MI23D00001')
*/
order by 1 /*hr_emppay.position*/

--E005818 --v two rows 