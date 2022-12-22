/*hr_emp_WorkerLicenses*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Worker Licenses' as TabName
,'hr_emp_WorkerLicenses' as QueryName
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
  RIGHT JOIN [production_finance].[dbo].hr_licncert 
    ON hr_empmstr.ID = hr_licncert.ID and hr_licncert.licntype = 'D4'
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 /* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].hr_licncert 
    ON hr_empmstr.ID = hr_licncert.ID and hr_licncert.licntype = 'D4'
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
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
,upper(replace(replace(hr_licncert.regid, ' ',''),'-','')) /*(Only include records where hr_licncert.licntype = D4)*/ as 'LicenseID'
,IIF(hr_licncert.licntype = 'D4','Drivers License','') as 'LicenseType'
,'' as 'LicenseClass'
,'' as 'IssuedDate'
,'' as 'ExpirationDate'
,'' as 'VerificationDate'
,'USA-MI' as 'CountryRegion'
,'' as 'Authority'
from [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].hr_licncert 
    ON hr_empmstr.ID = hr_licncert.ID and hr_licncert.licntype = 'D4'
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 ORDER BY 1