/*EMP-Biographic Data*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'Biographic Data' as TabName
,'EMP-Biographic Data' as QueryName
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
FROM 	  [production_finance].[dbo].[hr_empmstr]
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM 	  [production_finance].[dbo].[hr_empmstr]
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,replace(convert(varchar, hr_empmstr.bdt, 106),' ','-') as 'DateofBirth'
,'' as 'CountryofBirth'
,'' as 'RegionofBirth'
,'' as 'CityofBirth'
,'' as 'DateofDeath'
,CASE 
  WHEN hr_empmstr.gender='F' THEN 'Female'
  WHEN hr_empmstr.gender='M' THEN 'Male' 
  ELSE hr_empmstr.gender 
  END as 'Gender'
,'' as 'Disability#1'
,'' as 'DisabilityStatusDate#1'
,'' as 'DisabilityDateKnown#1'
,'' as 'DisabilityEndDate#1'
,'' as 'DisabilityGrade#1'
,'' as 'DisabilityDegree#1'
,'' as 'DisabilityRemainingCapacity#1'
,'' as 'DisabilityCertificationAuthority#1'
,'' as 'DisabilityCertifiedAt#1'
,'' as 'DisabilityCertificationID#1'
,'' as 'DisabilityCertificationBasis#1'
,'' as 'DisabilitySeverityRecognitionDate#1'
,'' as 'DisabilityFTETowardQuota#1'
,'' as 'DisabilityWorkRestrictions#1'
,'' as 'DisabilityAccommodationsRequested#1'
,'' as 'DisabilityAccommodationsProvided#1'
,'' as 'DisabilityRehabilitationRequested#1'
,'' as 'DisabilityRehabilitationProvided#1'
,'' as 'Note#1'
,'' as 'TobaccoUserStatus'
,'' as 'BloodType'
,'' as 'SexualOrientation'
,'' as 'GenderIdentity'
,'' as 'Pronoun'
,'' as 'LGBTIdentification#1'
,'' as 'LGBTIdentification#2'
FROM 	  [production_finance].[dbo].[hr_empmstr]
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','PENS','ROAD')
order by 1