--Pay - USA-EE Payroll History

select 
	 hr_empmstr.id as 'R-EmployeeID'
	,'Steve Smigiel' as 'O-SourceSystem'
	,x.QTR as 'R-Quarter'
	,'Bi-weekly' as 'R-PayGroup'
	,iif(hr_empmstr.ENTITY_ID ='ROOT',
	       'County of Macomb',
			 'Macomb County Employees Retirement System') as 'R-Company'
	,'' as 'O-CostCenter'
	,'' as 'O-PositionID'
	,CASE 
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 1 THEN '03/18/2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 1 THEN '03/31/2022'
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 2 THEN '06/24/2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 2 THEN '06/30/2022'
	  ELSE 'TBD' 
	  END as 'R-PeriodEndDate'
	,CASE 
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 1 THEN '03/25/2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 1 THEN '04/01/2022'
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 2 THEN '07/01/2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 2 THEN '07/01/2022'
	  ELSE 'TBD' 
	END as 'R-PaymentDate'
	,'' as 'O-ThirdPartySickPay'
	,x.QTREarnings_CD as 'O-EarningCode'
	,IIF(earn.[earnDesc] is null,'',earn.[earnDesc]) as  etest 
	,IIF(deduct.[DeductDesc] is null,'',deduct.[DeductDesc]) as dtest
	,x.QTRDeduct_CD as 'O-DeductionCode'
	,x.QTRAmount as 'R-Amount'
	,'' as 'O-TaxableWages'
	,'' as 'O-SubjectWages'
	,'' as 'O-GrossWages'
	,'' as 'O-SupplementalWages'
	,'' as 'O-WithholdingOrder-CaseNumber'
	,'' as 'O-PayrollStateTaxAuthority'
	,'' as 'O-PayrollLocalCountyTaxAuthorityCode'
	,'' as 'O-PayrollLocalCityTaxAuthorityCode'
	,'' as 'O-PayrollLocalHomeSchoolDistrictTaxAuthorityCode'
	,'' as 'O-PayrollLocalOtherTaxAuthorityCode'
	,'' as 'O-FlexiblePaymentDeductionWorktag'
	,'' as 'O-CustomWorktag#1'
	,'' as 'O-CustomWorktag#2'
	,'' as 'O-CustomWorktag#3'
	,'' as 'O-CustomWorktag#4'
	,'' as 'O-CustomWorktag#5'
	,'' as 'O-CustomWorktag#6'
	,'' as 'O-CustomWorktag#7'
	,'' as 'O-CustomWorktag#8'
	,'' as 'O-CustomWorktag#9'
	,'' as 'O-CustomWorktag#10'
	,'' as 'O-RelatedCalculationID'
	,'' as 'O-RelatedCalcInputValue'
 
from [production_finance].[dbo].[hr_empmstr] 
		left join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
		left join (
		SELECT
			xtdQ1.HR_PE_ID as ID
			,xtdQ1.pyx_yy as PayYear
			,1 as QTR
			--,xtdQ1.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd01 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ1
		WHERE (xtdQ1.pyx_no between 5000 and 5999 
				OR xtdQ1.pyx_no between 1000 and 1999 
				OR xtdQ1.pyx_no between 2000 and 2999)
				and xtdQ1.pyx_yy = 2022
				and xtdQ1.pyx_qtd01 > 0
				--and ehr.ID = xtdQ1.HR_PE_ID
		UNION ALL
		SELECT
			xtdQ2.HR_PE_ID as ID
			,xtdQ2.pyx_yy as PayYear
			,2 as QTR
			--,xtdQ2.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd02 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ2
		WHERE (xtdQ2.pyx_no between 5000 and 5999 
				OR xtdQ2.pyx_no between 1000 and 1999 
				OR xtdQ2.pyx_no between 2000 and 2999)
				and xtdQ2.pyx_yy = 2022
				and xtdQ2.pyx_qtd02 > 0
				--and ehr.ID = xtdQ2.HR_PE_ID
		UNION ALL
		SELECT
			xtdQ3.HR_PE_ID as ID
			,xtdQ3.pyx_yy as PayYear
			,3 as QTR
			--,xtdQ3.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd03 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ3
		WHERE (xtdQ3.pyx_no between 5000 and 5999 
				OR xtdQ3.pyx_no between 1000 and 1999 
				OR xtdQ3.pyx_no between 2000 and 2999)
				and xtdQ3.pyx_yy = 2022
				and xtdQ3.pyx_qtd03 > 0
				--and ehr.ID = xtdQ3.HR_PE_ID
		UNION ALL
		SELECT
			xtdQ4.HR_PE_ID as ID
			,xtdQ4.pyx_yy as PayYear
			,4 as QTR
			--,xtdQ4.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd04 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ4
		WHERE (xtdQ4.pyx_no between 5000 and 5999 
				OR xtdQ4.pyx_no between 1000 and 1999 
				OR xtdQ4.pyx_no between 2000 and 2999)
				and xtdQ4.pyx_yy = 2022
				and xtdQ4.pyx_qtd04 > 0
				--and ehr.ID = xtdQ4.HR_PE_ID
		) x on hr_empmstr.ID = x.ID
		LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Deductions] deduct
			ON x.QTRDeduct_CD = deduct.[Code]
		LEFT JOIN [IT.Macomb_DBA].[dbo].[Equiv_Earnings] earn
			ON x.QTREarnings_CD = earn.[Code]

		where  hr_empmstr.ID = 'E003542'