/*worker addresses*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Worker Address' as TabName
,'worker addresses' as QueryName
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
where hr_empmstr.ENTITY_ID in ('ROOT','ROAD','PENS')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','ROAD','PENS')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




select 
trim(hr_empmstr.id) as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'AddressEffectiveDate'
,'Y' as 'Primary' -- where is the field and the work address
,'Home' as 'UsageType' -- where is this???
,'N' as 'Public' -- where is this???
,trim(hr_empmstr.country) as 'CountryISOCode'
--c&p ,IIF(hr_empmstr.st_2 is null, trim(hr_empmstr.st_1),CONCAT (trim(hr_empmstr.st_1),', ',trim(hr_empmstr.st_2))) as 'AddressLine_1'
,trim(hr_empmstr.st_1) as 'AddressLine#1'
,trim(hr_empmstr.st_2) as 'AddressLine#2'
,trim(hr_empmstr.city) as 'City'
,IIF(hr_empmstr.id ='R001197' --Panama Res.
	,'PAN-10'
	,trim(hr_empmstr.country) + '-' + trim(hr_empmstr.state)) as 'Region'
,trim(hr_empmstr.zip) as 'PostalCode'
,'' as 'UseForReference1'
,'' as 'UseForReference2'
,IIF(hr_empmstr.id = 'E022064','Y','') as 'Work_From_home_address'

from [production_finance].[dbo].[hr_empmstr]
where hr_empmstr.ENTITY_ID in ('ROOT','ROAD','PENS')
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/*hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
/*AND hr_empmstr.id in (
'R001197'
)--*/
order by 1
