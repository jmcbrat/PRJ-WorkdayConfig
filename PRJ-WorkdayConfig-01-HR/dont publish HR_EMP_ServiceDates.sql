/*HR_EMP_ServiceDates*/
SELECT
hr_empmstr.id as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,hr_empmstr.beg as 'OriginalHireDate'
,hr_empmstr.hdt as 'ContinuousServiceDate'
,'' as 'ExpectedRetirementDate'
,'' as 'RetirementEligibilityDate'
,'' as 'SeniorityDate'
,'' as 'SeveranceDate'
,'' as 'BenefitsServiceDate'
,'' as 'CompanyServiceDate'
,CASE /*need to validate this is correct */ 
  WHEN hr_empmstr.entity_id IN ('ROOT','ROAD') THEN convert(varchar,hr_empmstr.hrdate2,106)
  WHEN hr_empmstr.entity_id = 'PENS' THEN ''
  ELSE ''
END AS 'TimeOffServiceDate'
,'' as 'VestingDate'
FROM [production_finance].[dbo].[hr_empmstr]
WHERE hr_empmstr.ENTITY_ID IN ('ROOT','ROAD','PENS')