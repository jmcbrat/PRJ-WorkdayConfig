--pay_Payroll_W-4 Elections
SELECT 
hr_empmstr.id as 'R-EmployeeID'
,'OneSolution' as 'O-SourceSystem'
,pyd_cdh_dtl.pyd_beg as 'R-EffectiveAsOf'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'County of Macomb',
		 'Macomb County Employees Retirement System') as 'R-Company'
,pyd_cdh_dtl.pyd_spec_cd_01 as 'R-PayrollW-4MaritalStatus'
,pyd_cdh_dtl.pyd_spec_cd_02 as 'O-NumberofAllowances'
,'' as 'O-AdditionalAmount'
,'' as 'O-MultipleJobs'
,pya_assoc_dtl.pya_assoc_desc as 'O-TotalDependentAmount'
,pya_assoc_dtl.pya_assoc_desc as 'O-OtherIncome'
,pya_assoc_dtl.pya_assoc_desc as 'O-Deductions'
,pya_assoc_dtl.pya_assoc_desc as 'O-Exempt'
,pya_assoc_dtl.pya_assoc_desc as 'O-NonresidentAlien'
,'' as 'O-ExemptfromNRAAdditionalAmount'
,IIF(pyd_cdh_dtl.pyd_spec_cd_04 = 'IRS','Y','N') as 'O-LockinLetter'
,'' as 'O-NoWageNoTaxIndicator'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(2100);