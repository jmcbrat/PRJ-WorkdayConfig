/*hr_emp_UnionMembership*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Union Membership' as TabName
,'hr_emp_UnionMembership' as QueryName
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
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'ROOT' and HR_EMPMSTR.BARGUNIT <> '00'
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
union all 
select 
IIF(hr_empmstr.hr_Status = 'I',hr_empmstr.Entity_id+'RET',hr_empmstr.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and  hr_empmstr.ENTITY_ID = 'ROAD' and HR_EMPMSTR.BARGUNIT <> '31'
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
union all
select
IIF(hr_empmstr.hr_Status = 'I',hr_empmstr.Entity_id+'RET',hr_empmstr.Entity_id+'CNT') as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'PENS' 
and not HR_EMPMSTR.BARGUNIT in ('00','31')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status


UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'ROOT' and HR_EMPMSTR.BARGUNIT <> '00'
/* end of grab */
union all
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and  hr_empmstr.ENTITY_ID = 'ROAD' and HR_EMPMSTR.BARGUNIT <> '31'
/* end of grab */
union all
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'PENS' 
and not HR_EMPMSTR.BARGUNIT in ('00','31')
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




SELECT
hr_empmstr.id as 'WorkerID'
,'R-Denise Krzeminski' as 'SourceSystem'
,hr_empmstr.bargunit as 'UnionID'
,'Active_Paid_Dues' as 'MembershipType'  -- need logic here for acive_no_paid check
,hr_empmstr.hrdate3 as 'UnionStartDate'
,hr_empmstr.hrdate3 as 'UnionSeniorityDate'
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'ROOT' and HR_EMPMSTR.BARGUNIT <> '00'
UNION ALL
/*PENS*/
SELECT
hr_empmstr.id as 'WorkerID'
,'C-Denise Krzeminski' as 'SourceSystem'
,hr_empmstr.bargunit as 'UnionID'
,'Active_Paid_Dues' as 'MembershipType'      -- need logic here for acive_no_paid check
,hr_empmstr.beg as 'UnionStartDate'
,hr_empmstr.hdt as 'UnionSeniorityDate'
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and  hr_empmstr.ENTITY_ID = 'ROAD' and HR_EMPMSTR.BARGUNIT <> '31'
UNION ALL
SELECT
hr_empmstr.id as 'WorkerID'
,'P-Denise Krzeminski' as 'SourceSystem'
,IIF(hr_empmstr.bargunit= 'UK','26',hr_empmstr.bargunit) as 'UnionID'  --forced for R002645 to 26.... it was UK
,'Regular' as 'MembershipType'
,hr_empmstr.beg as 'UnionStartDate'
,hr_empmstr.hrdate3 as 'UnionSeniorityDate'
,'' as 'UnionEndDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.ENTITY_ID = 'PENS' 
and not HR_EMPMSTR.BARGUNIT in ('00','31')

order by 1