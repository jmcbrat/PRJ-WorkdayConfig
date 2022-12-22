--pay_Payroll_W-4 Elections
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'pay_Payroll' as Spreadsheet
,'W-4 Elections' as TabName
,'pay_Payroll_W-4 Elections' as QueryName
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
	left JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2100)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2100) AND PCH.HR_PE_ID = hr_empmstr.ID)
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] EEO4INFO
		ON hr_empmstr.id = EEO4INFO.HR_PE_ID AND EEO4INFO.PYA_ASSOC_CD = 'EEO4INFO' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX1C
		ON hr_empmstr.id = W4BOX1C.HR_PE_ID AND W4BOX1C.PYA_ASSOC_CD = 'W4 BOX1C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX2C
		ON hr_empmstr.id = W4BOX2C.HR_PE_ID AND W4BOX2C.PYA_ASSOC_CD = 'W4 BOX2C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4C
		ON hr_empmstr.id = W4BOX4C.HR_PE_ID AND W4BOX4C.PYA_ASSOC_CD = 'W4 BOX4C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX3
	ON hr_empmstr.id = W4BOX3.HR_PE_ID AND W4BOX3.PYA_ASSOC_CD = 'W4 BOX3C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4A
	ON hr_empmstr.id = W4BOX4A.HR_PE_ID AND W4BOX4A.PYA_ASSOC_CD = 'W4 BOX4A' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4B
	ON hr_empmstr.id = W4BOX4B.HR_PE_ID AND W4BOX4B.PYA_ASSOC_CD = 'W4 BOX4B' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4EXMPT
	ON hr_empmstr.id = W4EXMPT.HR_PE_ID AND W4EXMPT.PYA_ASSOC_CD = 'W4 EXMPT' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4NRAL
	ON hr_empmstr.id = W4NRAL.HR_PE_ID AND W4NRAL.PYA_ASSOC_CD = 'W4 NRAL' /*does not exist*/

WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
	left JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2100)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2100) AND PCH.HR_PE_ID = hr_empmstr.ID)
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] EEO4INFO
		ON hr_empmstr.id = EEO4INFO.HR_PE_ID AND EEO4INFO.PYA_ASSOC_CD = 'EEO4INFO' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX1C
		ON hr_empmstr.id = W4BOX1C.HR_PE_ID AND W4BOX1C.PYA_ASSOC_CD = 'W4 BOX1C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX2C
		ON hr_empmstr.id = W4BOX2C.HR_PE_ID AND W4BOX2C.PYA_ASSOC_CD = 'W4 BOX2C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4C
		ON hr_empmstr.id = W4BOX4C.HR_PE_ID AND W4BOX4C.PYA_ASSOC_CD = 'W4 BOX4C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX3
	ON hr_empmstr.id = W4BOX3.HR_PE_ID AND W4BOX3.PYA_ASSOC_CD = 'W4 BOX3C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4A
	ON hr_empmstr.id = W4BOX4A.HR_PE_ID AND W4BOX4A.PYA_ASSOC_CD = 'W4 BOX4A' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4B
	ON hr_empmstr.id = W4BOX4B.HR_PE_ID AND W4BOX4B.PYA_ASSOC_CD = 'W4 BOX4B' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4EXMPT
	ON hr_empmstr.id = W4EXMPT.HR_PE_ID AND W4EXMPT.PYA_ASSOC_CD = 'W4 EXMPT' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4NRAL
	ON hr_empmstr.id = W4NRAL.HR_PE_ID AND W4NRAL.PYA_ASSOC_CD = 'W4 NRAL' /*does not exist*/

WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;






SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,'Steve Smigiel' as 'SourceSystem'
,IIF(pyd_cdh_dtl.pyd_beg<hr_empmstr.hdt
	,replace(convert(varchar, hr_empmstr.hdt, 106),' ','-')
	,replace(convert(varchar, pyd_cdh_dtl.pyd_beg, 106),' ','-')) as 'EffectiveAsOf'
,iif(hr_empmstr.ENTITY_ID ='ROOT',
       'C0001' /*County of Macomb*/,
		 'C0005' /*'Macomb County Employees Retirement System'*/) as 'Company'
,CASE
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'S' THEN 'Single' 
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'M' THEN 'Married filing jointly'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'H' THEN 'Head of Household'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'X' THEN 'Married filing separately'
	WHEN pyd_cdh_dtl.pyd_spec_cd01 = 'E' THEN 'Single'
	ELSE ''
	END as 'PayrollW-4MaritalStatus'
--Why not same logic as below?
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,convert(varchar,pyd_cdh_dtl.pyd_spec_cd02)
	  ,'') as 'NumberofAllowances'
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,pyd_cdh_dtl.pyd_add/100
	  ,IIF(W4BOX4C.pya_assoc_cd = 'W4 BOX4C',
		      cast(W4BOX4C.pya_assoc_desc as decimal(12,2))/100,
				0)) as 'AdditionalAmount' --E001108 should have 125 
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,''
	  ,'N') as 'MultipleJobs'
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,''
	  ,isnull(W4BOX3.pya_assoc_desc,'')) as 'TotalDependentAmount'
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,''
	  ,isnull(W4BOX4A.pya_assoc_desc,'')) as 'OtherIncome'
,IIF((pyd_cdh_dtl.pyd_beg <'01/01/2020' 
     AND pyd_cdh_dtl.pyd_add_end > '4/1/2022')
	  ,''
	  ,isnull(W4BOX4B.pya_assoc_desc,'')) as 'Deductions'
,IIF(pyd_cdh_dtl.pyd_beg >='01/01/2020', 
      ISNULL(W4EXMPT.pya_assoc_desc,'N'),
		'N') as 'Exempt'
,IIF(pyd_cdh_dtl.pyd_beg >='01/01/2020', 
      ISNULL(W4NRAL.pya_assoc_desc,'N'),
		'N') as 'NonresidentAlien'
,'N' as 'ExemptfromNRAAdditionalAmount'
,IIF(pyd_cdh_dtl.pyd_spec_cd04 = 'IRS','Y','N') as 'LockinLetter'
,'' as 'NoWageNoTaxIndicator'
/*,'---pyd_cdh_dtl---'
,pyd_cdh_dtl.*
,'---box4c---'
,W4BOX4C.**/
FROM [production_finance].[dbo].[hr_empmstr]
	left JOIN [production_finance].[dbo].[pyd_cdh_dtl]
		ON hr_empmstr.id = pyd_cdh_dtl.HR_PE_ID
		  AND pyd_cdh_dtl.py_CDH_NO in(2100)
		  AND pyd_cdh_dtl.pyd_beg = (select max(PCH.pyd_beg) from [production_finance].[dbo].[pyd_cdh_dtl] PCH where PCH.py_CDH_NO in(2100) AND PCH.HR_PE_ID = hr_empmstr.ID)
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] EEO4INFO
		ON hr_empmstr.id = EEO4INFO.HR_PE_ID AND EEO4INFO.PYA_ASSOC_CD = 'EEO4INFO' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX1C
		ON hr_empmstr.id = W4BOX1C.HR_PE_ID AND W4BOX1C.PYA_ASSOC_CD = 'W4 BOX1C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX2C
		ON hr_empmstr.id = W4BOX2C.HR_PE_ID AND W4BOX2C.PYA_ASSOC_CD = 'W4 BOX2C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4C
		ON hr_empmstr.id = W4BOX4C.HR_PE_ID AND W4BOX4C.PYA_ASSOC_CD = 'W4 BOX4C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX3
	ON hr_empmstr.id = W4BOX3.HR_PE_ID AND W4BOX3.PYA_ASSOC_CD = 'W4 BOX3C' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4A
	ON hr_empmstr.id = W4BOX4A.HR_PE_ID AND W4BOX4A.PYA_ASSOC_CD = 'W4 BOX4A' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4BOX4B
	ON hr_empmstr.id = W4BOX4B.HR_PE_ID AND W4BOX4B.PYA_ASSOC_CD = 'W4 BOX4B' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4EXMPT
	ON hr_empmstr.id = W4EXMPT.HR_PE_ID AND W4EXMPT.PYA_ASSOC_CD = 'W4 EXMPT' 
	left JOIN [production_finance].[dbo].[pya_assoc_dtl] W4NRAL
	ON hr_empmstr.id = W4NRAL.HR_PE_ID AND W4NRAL.PYA_ASSOC_CD = 'W4 NRAL' /*does not exist*/

WHERE hr_empmstr.entity_id in ('ROOT','PENS')
  AND hr_empmstr.hr_status = 'A'

  order by hr_empmstr.id
