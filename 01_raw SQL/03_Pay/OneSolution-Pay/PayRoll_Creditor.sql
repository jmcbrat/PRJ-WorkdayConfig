--PayRoll_Creditor (USA)
SELECT
hr_empmstr.id as 'R-EmployeeID'
,'Steve Smigiel' as 'O-SourceSystem'
,'Creditor' as 'R-WithholdingOrderTypeID'
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
,'PERCENTDE' as 'R-WithholdingOrderAmountType'
,'' as 'O-WithholdingOrderAmount'
,0.25 as 'O-WithholdingOrderAmountasPercent'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Bi-weekly','Monthly') as 'R-FrequencyID'
,99999999999 as 'R-TotalDebtAmountRemaining'
,'' as 'O-MonthlyLimit'
,'' as 'R-Code(IssuedinReference)'
,'DR-001' as 'R-DeductionRecipientID'
,'' as 'O-OriginatingAuthority'
,'' as 'O-Memo'
,'' as 'O-Currency'
,'General Creditor' as 'R-CreditorGarnishmentType'
,'' as 'O-HeadofHousehold'
,'' as 'O-NumberofDependents'
,'' as 'O-WorkerisLaborerorMechanic'
,'' as 'O-WorkerIncomeisPovertyLevel'
,'' as 'O-GoodCauseLimitPercent'
,'' as 'O-WeeklyGrossWages'
,'' as 'O-ExpectedAnnualEarnings'
,0 as 'R-FeeAmount#1'
,0 as 'R-FeePercent#1'
,'EMPLFEE' as 'R-FeeTypeID#1'
,'AMOUNT' as 'R-FeeAmountTypeID#1'
,'' as 'O-DeductionRecipientID#1'
,'' as 'O-OverrideFeeSchedule#1'
,'' as 'O-BeginDate#1'
,'' as 'O-EndDate#1'
,0 as 'R-FeeMonthlyLimit#1'
,0 as 'R-FeeAmount#2'
,0 as 'R-FeePercent#2'
,'' as 'R-FeeTypeID#2'
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
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(2350,2351,2365,2366,2367,2368,2369,2370,
                               2371,2372,2373,2374,2375,2376,2377,2378,2379,
										 2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,
										 2390,2391,2392,2393)
  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
                             from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
									  where PCH.py_CDH_NO 
									    in(2350,2351,2365,2366,2367,2368,2369,2370,
                               2371,2372,2373,2374,2375,2376,2377,2378,2379,
										 2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,
										 2390,2391,2392,2393) AND PCH.HR_PE_ID = hr_empmstr.ID)
  AND pyd_cdh_dtl.pyd_end >'04/01/2022'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id