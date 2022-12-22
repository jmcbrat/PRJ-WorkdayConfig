/*hr_EMP_Worker Government IDs*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Worker Government IDs' as TabName
,'hr_EMP_Worker Government IDs' as QueryName
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
where  hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	     and hr_empmstr.termcode <> 'NVST'))
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
where  hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	     and hr_empmstr.termcode <> 'NVST'))
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



SELECT
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'USA' as 'CountryISOCode'
,'National' as 'Type'
,'USA-SSN' as 'WorkdayIDType'
,replace(replace(hr_empmstr.ssn,'-',''),' ','') as 'ID'
,'' as 'IssuedDate'
,'' as 'ExpirationDate'
,'' as 'VerificationDate'
,'' as 'Series-NationalID'
,'' as 'IssuingAgency-NationalID'
from [production_finance].[dbo].[hr_empmstr]
where  hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	     and hr_empmstr.termcode <> 'NVST'))

 ORDER BY 1