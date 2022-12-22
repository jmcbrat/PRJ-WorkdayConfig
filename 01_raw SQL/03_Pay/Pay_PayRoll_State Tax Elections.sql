--Pay_PayRoll_State Tax Elections
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'Pay_PayRoll' as Spreadsheet
,'State Tax Elections' as TabName
,'Pay_PayRoll_State Tax Elections' as QueryName
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
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	  AND pyd_cdh_dtl.py_CDH_NO in(2101)
	  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2101) AND PCH.HR_PE_ID = hr_empmstr.ID)
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E002665')

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	  AND pyd_cdh_dtl.py_CDH_NO in(2101)
	  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2101) AND PCH.HR_PE_ID = hr_empmstr.ID)
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E002665')

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;





SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'Company'
,IIF(pyd_cdh_dtl.pyd_beg<hr_empmstr.hdt
	,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')
	,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-')) as 'EffectiveAsOf'
,CASE
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'S' THEN 'Single' 
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'M' THEN 'Married filing jointly'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'H' THEN 'Head of Household'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'X' THEN 'Married filing separately'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'E' THEN 'Single'
	ELSE ''
	END as  'PayrollMaritalStatusReference'
,IIF(hr_empmstr.id = 'E022064','17','26') as 'PayrollStateTaxAuthority'
,'' as 'MarriedFilingJointlyOptionalCalculation'
,'' as 'VeteranExemption'
,'' as 'ExemptionforDependentsComplete'
,'' as 'ExemptionforDependentsJointCustody'
,'' as 'AllowanceonSpecialDeduction'
,'' as 'NewJerseyRateTableSpecification'
,'' as 'NumberofAllowances'
,'' as 'ExemptionsforMississippi'
,'' as 'EstimatedDeductions'
,'' as 'DependentAllowance'
,'' as 'AdditionalAllowance'
,'' as 'WithholdingExemption'
,'' as 'AllocationPercent'
,'' as 'AdditionalPercent'
,'' as 'ServicesLocalizedinIllinois'
,'' as 'ArizonaConstantPercent'
,pyd_cdh_dtl.pyd_add as 'AdditionalAmount'
,'' as 'AnnualWithholdingAmount'
,'' as 'ReducedWithholdingAmount'
,'' as 'EstimatedTaxCreditperPeriod'
,'' as 'Exempt'
,'' as 'ExemptReason'
,'' as 'WithholdingSubstantiated'
,'' as 'CertificateofNonResidence'
,'' as 'CertificateofResidence'
,'' as 'CertificateofWithholdingExemptionandCountyStatus'
,'' as 'HeadofHousehold'
,'' as 'EmployeeBlind'
,'' as 'SpouseIndicator'
,'' as 'Full-timeStudentIndicator'
,'' as 'LowerTaxRate'
,'' as 'InactivateStateTax'
,'' as 'LockinLetter'
,'' as 'ActiveDutyOklahoma'
,'' as 'FortCampbellExemptKentucky'
,'' as 'MSRRExempt'
,'' as 'EntrepreneurExemption'
,'' as 'DomicileStateTaxAuthority'
,'' as 'NoWageNoTaxIndicator'
,'' as 'IncreaseorDecreaseWithholdingAmount'
,'' as 'ReducedWithholdingperPayPeriod'
FROM [production_finance].[dbo].[hr_empmstr]
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	  AND pyd_cdh_dtl.py_CDH_NO in(2101)
	  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2101) AND PCH.HR_PE_ID = hr_empmstr.ID)
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E002665')

  order by hr_empmstr.id 