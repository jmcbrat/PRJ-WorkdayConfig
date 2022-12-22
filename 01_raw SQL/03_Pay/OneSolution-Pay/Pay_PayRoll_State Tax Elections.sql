--Pay_PayRoll_State Tax Elections
SELECT 
hr_empmstr.id as 'R-EmployeeID'
,'OneSolution' as 'O-SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'County of Macomb',
		 'Macomb County Employees Retirement System') as 'R-Company'
,pyd_cdh_dtl.pyd_beg as 'R-EffectiveAsOf'
,pyd_cdh_dtl.pyd_spec_cd_01 as 'O-PayrollMaritalStatusReference'
,if hr_empmstr.id = E022064 then 17 else 26 as 'R-PayrollStateTaxAuthority'
,'' as 'O-MarriedFilingJointlyOptionalCalculation'
,'' as 'O-VeteranExemption'
,'' as 'O-ExemptionforDependentsComplete'
,'' as 'O-ExemptionforDependentsJointCustody'
,'' as 'O-AllowanceonSpecialDeduction'
,'' as 'O-NewJerseyRateTableSpecification'
,'' as 'O-NumberofAllowances'
,'' as 'O-ExemptionsforMississippi'
,'' as 'O-EstimatedDeductions'
,'' as 'O-DependentAllowance'
,'' as 'O-AdditionalAllowance'
,'' as 'O-WithholdingExemption'
,'' as 'O-AllocationPercent'
,'' as 'O-AdditionalPercent'
,'' as 'O-ServicesLocalizedinIllinois'
,'' as 'O-ArizonaConstantPercent'
,pyd_cdh_dtl.pyd_add as 'O-AdditionalAmount'
,'' as 'O-AnnualWithholdingAmount'
,'' as 'O-ReducedWithholdingAmount'
,'' as 'O-EstimatedTaxCreditperPeriod'
,'' as 'O-Exempt'
,'' as 'O-ExemptReason'
,'' as 'O-WithholdingSubstantiated'
,'' as 'O-CertificateofNonResidence'
,'' as 'O-CertificateofResidence'
,'' as 'O-CertificateofWithholdingExemptionandCountyStatus'
,'' as 'O-HeadofHousehold'
,'' as 'O-EmployeeBlind'
,'' as 'O-SpouseIndicator'
,'' as 'O-Full-timeStudentIndicator'
,'' as 'O-LowerTaxRate'
,'' as 'O-InactivateStateTax'
,'' as 'O-LockinLetter'
,'' as 'O-ActiveDutyOklahoma'
,'' as 'O-FortCampbellExemptKentucky'
,'' as 'O-MSRRExempt'
,'' as 'O-EntrepreneurExemption'
,'' as 'O-DomicileStateTaxAuthority'
,'' as 'O-NoWageNoTaxIndicator'
,'' as 'O-IncreaseorDecreaseWithholdingAmount'
,'' as 'O-ReducedWithholdingperPayPeriod'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(2101)