/*oragnization assignments */
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Organization Assignments' as TabName
,'oragnization assignments' as QueryName
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
     --right join [production_finance].[dbo].[hr_emppay] 
     --on hr_empmstr.id = hr_emppay.id 
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2]
	  on trim(hr_empmstr.DEPARTMENT) = DEPT_CODES_LIST2.DEPTCD
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2] rDEPT_CODES_LIST2
	  on trim(hr_empmstr.HR10) = rDEPT_CODES_LIST2.DEPTCD

where --hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
  --and 
  hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr] 
     --right join [production_finance].[dbo].[hr_emppay] 
     --on hr_empmstr.id = hr_emppay.id 
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2]
	  on trim(hr_empmstr.DEPARTMENT) = DEPT_CODES_LIST2.DEPTCD
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2] rDEPT_CODES_LIST2
	  on trim(hr_empmstr.HR10) = rDEPT_CODES_LIST2.DEPTCD

where --hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
  --and 
  hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




SELECT 
trim(hr_empmstr.id) as 'WorkerID'
,'AZ-Org' as 'SourceSystem'
,'' as 'PositionID'
--,hr_emppay.position as 'PositionID'
,'' as 'O-EffectiveDate'
--,ISNULL(dept_codes_list2.Description,hr_empmstr.DEPARTMENT)
,CASE
  WHEN hr_empmstr.DEPARTMENT = 'BOC' THEN 'BOARD OF COMMISSION'
  WHEN hr_empmstr.DEPARTMENT = 'SHF' THEN 'COUNTY SHERIFF'
  WHEN hr_empmstr.DEPARTMENT = 'REG' THEN 'MACOMB COUNTY CLERK'
  WHEN hr_empmstr.DEPARTMENT = 'CLK' THEN 'MACOMB COUNTY CLERK'
  WHEN hr_empmstr.DEPARTMENT = 'TRS' THEN 'MACOMB COUNTY TREASURER'
  WHEN hr_empmstr.DEPARTMENT = 'PRS' THEN 'PROSECUTING ATTORNEY'
  WHEN hr_empmstr.DEPARTMENT = 'PWK' THEN 'PUBLIC WORKS COMMISSIONER'
  WHEN hr_empmstr.DEPARTMENT = 'CIR' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'DC1' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'DC2' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'FOC' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'FCJ' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'PCW' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'PDO' THEN 'COUNTY JUDICIARY SYSTEM'
  WHEN hr_empmstr.DEPARTMENT = 'CIP' THEN 'COUNTY SHERIFF'
  WHEN hr_empmstr.DEPARTMENT = 'RETG' THEN 'Retirees - General'
  --WHEN hr_empmstr.DEPARTMENT = 'RETirees' THEN 'use sup_orgs'  /*IS THIS REAL*/
  WHEN hr_empmstr.DEPARTMENT = 'RETS' THEN 'RETIREES - Sheriff'
  WHEN hr_empmstr.DEPARTMENT = 'RETR' THEN 'RETIREES - ROADS'
  WHEN hr_empmstr.DEPARTMENT = 'RETM' THEN 'Retirees - Martha T Berry'
  ELSE 'OFFICE OF COUNTY EXECUTIVE'  /* would rather define them than catcha all */
  END -- needs to be CC codes
  as 'CostCenterOrganization'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'CompanyOrganization'
,'' as 'RegionOrganization'
,'' as 'BusinessUnit'
,CASE
  WHEN hr_empmstr.ENTITY_ID in ('ROOT','ROAD') THEN DEPT_CODES_LIST2.description --(select TOP 1 description from [IT.Macomb_dba].[dbo].DEPT_CODES_LIST2 where deptcd = hr_empmstr.department)
  WHEN hr_empmstr.ENTITY_ID ='PENS' THEN RDEPT_CODES_LIST2.description --(select TOP 1 description from [IT.Macomb_dba].[dbo].DEPT_CODES_LIST2 where deptcd = hr_empmstr.hr10)
  ELSE ''
  END as 'Department'
,'' as 'CustomOrg2'
,'' as 'CustomOrg3'
,'' as 'CustomOrg4'
from [production_finance].[dbo].[hr_empmstr] 
     --right join [production_finance].[dbo].[hr_emppay] 
     --on hr_empmstr.id = hr_emppay.id 
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2]
	  on trim(hr_empmstr.DEPARTMENT) = DEPT_CODES_LIST2.DEPTCD
     left JOIN [IT.Macomb_DBA].[dbo].[DEPT_CODES_LIST2] rDEPT_CODES_LIST2
	  on trim(hr_empmstr.HR10) = rDEPT_CODES_LIST2.DEPTCD

where --hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
  --and 
  hr_empmstr.hr_status = 'A'
  and hr_empmstr.ENTITY_ID IN ('ROOT','PENS','ROAD')
  /*and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
order by 1