--PayCommon_Paycheck Delivery Options
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'PayCommon' as Spreadsheet
,'Paycheck Delivery Options' as TabName
,'PayCommon_Paycheck Delivery Options' as QueryName
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
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;





SELECT
	trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel' as 'SourceSystem'
	,CASE
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'MAIL' 
		ELSE ''
	 END as 'PayCheckDeliveryMethod'
	,CASE
		WHEN hr_empmstr.entity_id = 'ROOT' THEN 'Electronic_Copy'
		WHEN hr_empmstr.entity_id = 'PENS' THEN 'Paper_Copy' 
		ELSE ''
	END as 'PayslipPrintingOverride'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
