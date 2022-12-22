--Pay_PayRoll_Local Work City Tax Elections
SELECT 
,hr_empmstr.id  as 'R-EmployeeID'
,'Steve Smigiel' as 'O-SourceSystem'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'County of Macomb',
		 'Macomb County Employees Retirement System') as 'R-Company'
,pyd_cdh_dtl.pyd_beg as 'R-EffectiveAsOf'
,'' as 'R-PayrollLocalCityTaxAuthorityCode'
,'' as 'O-NumberofAllowances(Michigan)'
,'' as 'O-ConstantPercent(Michigan)'
,'' as 'O-ExemptIndicator(Michigan,Pennsylvania)'
,'' as 'O-ConstantText'
,'' as 'O-PreviousEmployerDeductedAmount(Pennsylvania)'
,'' as 'O-PrimaryEITPennsylvania'
,'' as 'O-NotSubjecttoEITPennsylvania'
,'' as 'O-AdditionalAmount'
,'' as 'O-LowIncomeThreshold'
,'' as 'O-CurrencyCode'
,'' as 'O-Inactive'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(2104,2106,2108,2111)
  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2104,2106,2108,2111) AND PCH.HR_PE_ID = hr_empmstr.ID)
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
