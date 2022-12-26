/*HR_EMP_AddRetireeStatus*/

insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Add Retiree Status' as TabName
,'HR_EMP_AddRetireeStatus' as QueryName
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
and hr_empmstr.entity_id = 'PENS'
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.entity_id = 'PENS'/* end of grab */
) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



SELECT
hr_empmstr.id as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'Add_Retiree_Status_Retiree_Retirement' as 'RetireeReason'
,CASE 
  WHEN hr_empmstr.department= 'RETS' THEN 'SUP_RETIREE SHERIFF' 
  WHEN hr_empmstr.department= 'RETR' THEN 'SUP_RETIREE ROADS'
  WHEN hr_empmstr.department ='RETM' THEN 'SUP_RETIREE MTB'
  WHEN hr_empmstr.department= 'RETG' THEN 'SUP_RETIREE GENERAL'
  ELSE ''
  END as 'RetireeOrg'
,hr_empmstr.hdt as 'RetireeStatusDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.HR_STATUS = 'A'
and hr_empmstr.entity_id = 'PENS'