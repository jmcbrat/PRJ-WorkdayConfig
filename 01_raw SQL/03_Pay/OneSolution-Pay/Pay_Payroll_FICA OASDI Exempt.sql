--Pay_Payroll_FICA OASDI Exempt
SELECT
hr_empmstr.id as 'R-EmployeeID'
,entities ROOT  as 'O-SourceSystem'
,County of Macomb as 'R-Company'
,'' as 'O-PositionID'
,'' as 'O-AllPositionsExempt?'
,pyd_cdh_dtl.pyd_beg as 'R-EffectiveAsOf'
,'' as 'O-ApplyToWorker'
,pyd_cdh_dtl.pyd_end = 12/31/2050 N, otherwise Y as 'R-ExemptfromOASDI'
,Other as 'O-OASDIExemptionReason'
FROM [production_finance].[dbo].[hr_empmstr]
	LEFT JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
WHERE hr_empmstr.entity_id in ('ROOT')
  AND hr_empmstr.hr_status = 'A'
  AND pyd_cdh_dtl.py_CDH_NO in(1103,2103);