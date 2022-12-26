--PayRoll_Wage Assignment (USA)
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'PayRoll' as Spreadsheet
,'Wage Assignment (USA)' as TabName
,'PayRoll_Wage Assignment' as QueryName
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
		  AND pyd_cdh_dtl.py_CDH_NO in(2352,2353,2365,2359,2382,2992)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											  where PCH.py_CDH_NO 
												 in(2352,2353,2365,2359,2382,2992) 
												 AND PCH.HR_PE_ID = hr_empmstr.ID)
		  AND pyd_cdh_dtl.pyd_end > '04/01/2022'
		  AND pyd_cdh_dtl.pyd_amt > 0
  --	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2352,2353,2365,2359,2382,2992)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											  where PCH.py_CDH_NO 
												 in(2352,2353,2365,2359,2382,2992) 
												 AND PCH.HR_PE_ID = hr_empmstr.ID)
		  AND pyd_cdh_dtl.pyd_end > '04/01/2022'
		  AND pyd_cdh_dtl.pyd_amt > 0
  --	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;







SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,'WAGE' as 'WithholdingOrderTypeID'
,trim(ISNULL(pyd_cdh_dtl.pyd_misc_l,'')) as 'CaseNumber'
,convert(varchar,pyd_cdh_dtl.py_cdh_no)  as 'WithholdingOrderAdditionalOrderNumber'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'OrderDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'ReceivedDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-') as 'BeginDate'
,replace(convert(varchar, pyd_cdh_dtl.pyd_end, 106),' ','-') as 'EndDate'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'Company'
,'' as 'Inactive'
,'AMT' as 'WithholdingOrderAmountType'
,pyd_cdh_dtl.pyd_amt as 'WithholdingOrderAmount'
,'' as 'WithholdingOrderAmountasPercent'
,IIF(hr_empmstr.entity_id = 'ROOT', 'Biweekly','Monthly') as 'FrequencyID'
,99999999999 as 'TotalDebtAmountRemaining'
,'' as 'MonthlyLimit'
,'26' as 'Code(IssuedinReference)'
,'DR-001' as 'DeductionRecipientID'
,'' as 'Memo'
,'' as 'Currency'
,'' as 'RegulatedLoan'
,'' as 'HeadofHousehold'
,'' as 'Married'
,'' as 'FeeAmount#1'
,'' as 'FeePercent#1'
,'' as 'FeeTypeID#1'
,'' as 'FeeAmountTypeID#1'
,'' as 'DeductionRecipientID#1'
,'' as 'OverrideFeeSchedule#1'
,'' as 'BeginDate#1'
,'' as 'EndDate#1'
,'' as 'FeeMonthlyLimit#1'
,'' as 'FeeAmount#2'
,'' as 'FeePercent#2'
,'' as 'FeeTypeID#2'
,'' as 'FeeAmountTypeID#2'
,'' as 'DeductionRecipientID#2'
,'' as 'OverrideFeeSchedule#2'
,'' as 'BeginDate#2'
,'' as 'EndDate#2'
,'' as 'FeeMonthlyLimit#2'
FROM [production_finance].[dbo].[hr_empmstr]
	right JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2352,2353,2365,2359,2382,2992)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) 
											  from [production_finance].[dbo].[pyd_cdh_dtl] PCH 
											  where PCH.py_CDH_NO 
												 in(2352,2353,2365,2359,2382,2992) 
												 AND PCH.HR_PE_ID = hr_empmstr.ID)
		  AND pyd_cdh_dtl.pyd_end > '04/01/2022'
		  AND pyd_cdh_dtl.pyd_amt > 0
  --	LEFT JOIN [production_finance].[dbo].[pya_assoc_dtl]
--		ON hr_empmstr.id = pya_assoc_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'
  --AND ID in ('E003542')

  ORDER BY hr_empmstr.id
