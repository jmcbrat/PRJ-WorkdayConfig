--PayCommon_Paycheck Delivery Options

SELECT
	hr_empmster.id as 'R-EmployeeID'
	,hr_empmstr.entity_id as 'O-SourceSystem'
	,'' as 'O-PayCheckDeliveryMethod'
	,'' as 'O-PayslipPrintingOverride'
FROM 