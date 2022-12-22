--PayRoll_Federal Tax Levy (USA)
SELECT
hr_empmstr.id as 'R-EmployeeID'
,'Steve Smigiel' as 'O-SourceSystem'
,'FEDLEVY' as 'R-WithholdingOrderTypeID'
,pyd_cdh_dtl.pyd_misc_l as 'R-CaseNumber'
,pyd_cdh_dtl.py_cdh_no  as 'O-WithholdingOrderAdditionalOrderNumber'
,pyd_cdh_dtl.pyd_beg as 'R-OrderDate'
,pyd_cdh_dtl.pyd_beg as 'R-ReceivedDate'
,pyd_cdh_dtl.pyd_beg as 'R-BeginDate'
,pyd_cdh_dtl.pyd_end as 'O-EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'County of Macomb',
		 'Macomb County Employees Retirement System') as 'R-Company'
,'' as 'O-Inactive'
,'AMT' as 'R-WithholdingOrderAmountType'
,'' as 'O-WithholdingOrderAmount'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Bi-weekly','Monthly') as 'R-FrequencyID'
,99999999999 as 'R-TotalDebtAmountRemaining'
,'FEDERAL' as 'R-Code(IssuedinReference)'
,'DR-001' as 'R-DeductionRecipientID'
,'' as 'O-Memo'
,'' as 'O-Currency'
,'' as 'O-TaxLevySignedPart3Date'
,'' as 'O-PayrollMaritalStatusReference'
,'' as 'O-PersonalExemptions'
,'' as 'O-AdditionalExemptions65orBlind'
,'' as 'O-ExemptionAmountOverride'
,'' as 'O-ExemptionFrequency'
,'' as 'O-TaxLevyTerminationDate'
,'' as 'O-DependentName'
,'' as 'O-DependentIdentificationNumber'
,'' as 'O-LockTaxElections'
,'' as 'O-LoadBaselineRestrictions'
,0 as 'R-FeeAmount#1'
,0 as 'R-FeePercent#1'
,'EMPLFEE_PER' as 'R-FeeTypeID#1'
,'AMOUNT' as 'R-FeeAmountTypeID#1'
,'' as 'O-DeductionRecipientID#1'
,'' as 'O-OverrideFeeSchedule#1'
,'' as 'O-BeginDate#1'
,'' as 'O-EndDate#1'
,0 as 'R-FeeMonthlyLimit#1'
,0 as 'R-FeeAmount#2'
,0 as 'R-FeePercent#2'
,0 as 'R-FeeTypeID#2'
,'AMOUNT' as 'R-FeeAmountTypeID#2'
,'' as 'O-DeductionRecipientID#2'
,'' as 'O-OverrideFeeSchedule#2'
,'' as 'O-BeginDate#2'
,'' as 'O-EndDate#2'
,0 as 'R-FeeMonthlyLimit#2'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
--	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(2458,2461,2462)
  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
                             from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
									  where PCH.py_CDH_NO 
									    in(2458,2461,2462) 
										 AND PCH.HR_PE_ID = hr_empmstr.ID)
  AND pyd_cdh_dtl.pyd_end >'04/01/2022'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
