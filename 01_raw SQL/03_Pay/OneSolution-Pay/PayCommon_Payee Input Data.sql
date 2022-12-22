--PayCommon_Payee Input Data
SELECT 
	hr_empmstr.id as 'R-EmployeeID'
	,'OneSolution'   as 'O-SourceSystem'
,pyd_cdh_dtl.py_cdh_no
	,'' as 'O-PositionID'
	,'' as 'O-OngoingInput'
	,pyd_cdh_dtl.pyd_beg as 'R-StartDate'
	,pyd_cdh_dtl.pyd_beg as 'O-EndDate'
	,'lookup equivalencies from pyd_cdh_dtl.py_cdh_no'  as 'O-EarningCode'
	,'lookup equivalencies from pyd_cdh_dtl.py_cdh_no'  as 'O-DeductionCode'
	,pyd_cdh_dtl.pyd_amt as 'O-Amount'
	,'' as 'O-Hours'
	,'' as 'O-Rate'
	,'' as 'O-Adjustment?'
	,'' as 'O-Comment'
	,'USD' as 'O-Currency'
	,'' as 'O-StateAuthority'
	,'' as 'O-FlexiblePaymentDeductionWorktag'
	,'' as 'O-CustomWorktag#1'
	,'' as 'O-CustomWorktag#2'
	,'' as 'O-CustomWorktag#3'
	,'' as 'O-CustomWorktag#4'
	,'' as 'O-CustomWorktag#5'
	,'' as 'O-RelatedCalculationID'
	,'' as 'O-InputValue'
	,'' as 'O-RelatedCalculationID#2'
	,'' as 'O-InputValue#2'
	,'' as 'O-RelatedCalculationID#3'
	,'' as 'O-InputValue#3'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
