--HR_EMP-Calculated Plans
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Compensation_Template_Calculate Plan tab_Mapped.xlsx' as Spreadsheet
,'EMP-Calculated Plans' as TabName
,'HR_EMP-Calculated Plans' as QueryName
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
WHERE hr_empmstr.ENTITY_ID in ('ROOT')
  AND hr_empmstr.longevity is not null
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT')
  AND hr_empmstr.longevity is not null
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;


SELECT
hr_empmstr.id as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY hr_empmstr.id ORDER BY hr_empmstr.id ) as 'Sequence#'
,'Request_Compensation_Change_Conversion_Conversion' as 'CompensationChangeReason'
,'' as 'PositionID'
,hr_empmstr.longevity as 'EffectiveDate'
,'Longevity_Plan' as 'CalculatedPlan#1'
,'' as 'AmountOverride#1'
,'' as 'CurrencyCode-CalculatedPlan#1'
,'' as 'Frequency-CalculatedPlan#1'
,'' as 'CalculatedPlan#2'
,'' as 'AmountOverride#2'
,'' as 'CurrencyCode-CalculatedPlan#2'
,'' as 'Frequency-CalculatedPlan#2'
from [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID in ('ROOT')
  AND hr_empmstr.longevity is not null

ORDER by 1