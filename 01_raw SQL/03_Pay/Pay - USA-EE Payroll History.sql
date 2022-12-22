--Pay - USA-EE Payroll History
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'Pay' as Spreadsheet
,'USA-EE Payroll History' as TabName
,'Pay - USA-EE Payroll History' as QueryName
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
from [production_finance].[dbo].[hr_empmstr] 
		right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
		right join (
		SELECT
			xtdQ1.HR_PE_ID as ID
			,xtdQ1.pyx_yy as PayYear
			,1 as QTR
			--,xtdQ1.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd01/100 as QTRAmount
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
			,pyx_qtd02/100 as QTRAmount
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
			,pyx_qtd03/100 as QTRAmount
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
			,pyx_qtd04/100 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ4
		WHERE (xtdQ4.pyx_no between 5000 and 5999 
				OR xtdQ4.pyx_no between 1000 and 1999 
				OR xtdQ4.pyx_no between 2000 and 2999)
				and xtdQ4.pyx_yy = 2022
				and xtdQ4.pyx_qtd04 > 0
				--and ehr.ID = xtdQ4.HR_PE_ID
		) x on hr_empmstr.ID = x.ID
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Earnings ON x.QTREarnings_CD = Equiv_Earnings.code
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Deductions ON x.QTRDeduct_CD = Equiv_Deductions.code
--		where  hr_empmstr.ID = 'E003542' -- testing
		WHERE hr_empmstr.entity_id in ('ROOT')
		and x.QTREarnings_CD not in ('5919','3919')

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr] 
		right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
		right join (
		SELECT
			xtdQ1.HR_PE_ID as ID
			,xtdQ1.pyx_yy as PayYear
			,1 as QTR
			--,xtdQ1.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd01/100 as QTRAmount
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
			,pyx_qtd02/100 as QTRAmount
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
			,pyx_qtd03/100 as QTRAmount
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
			,pyx_qtd04/100 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ4
		WHERE (xtdQ4.pyx_no between 5000 and 5999 
				OR xtdQ4.pyx_no between 1000 and 1999 
				OR xtdQ4.pyx_no between 2000 and 2999)
				and xtdQ4.pyx_yy = 2022
				and xtdQ4.pyx_qtd04 > 0
				--and ehr.ID = xtdQ4.HR_PE_ID
		) x on hr_empmstr.ID = x.ID
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Earnings ON x.QTREarnings_CD = Equiv_Earnings.code
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Deductions ON x.QTRDeduct_CD = Equiv_Deductions.code
--		where  hr_empmstr.ID = 'E003542' -- testing
		WHERE hr_empmstr.entity_id in ('ROOT')
		and x.QTREarnings_CD not in ('5919','3919')

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;











select 
	 trim(hr_empmstr.id) as 'EmployeeID'
	,'Steve Smigiel' as 'SourceSystem'
	,convert(varchar,x.QTR) as 'Quarter'
	,'Biweekly' as 'PayGroup'
	,iif(hr_empmstr.ENTITY_ID ='ROOT',
			 'C0001' /*County of Macomb*/,
			 'C0005' /*'Macomb County Employees Retirement System'*/)  as 'Company'
	,'' /*convert(varchar,hr_emppay.payclass)*/ as 'CostCenter'
	,'' as 'PositionID'
	,CASE 
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 1 THEN '18-MAR-2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 1 THEN '31-MAR-2022'
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 2 THEN '24-JUN-2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 2 THEN '30-JUN-2022'
	  ELSE 'TBD' 
	  END as 'PeriodEndDate'
	,CASE 
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 1 THEN '25-MAR-2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 1 THEN '01-APR-2022'
	  WHEN hr_empmstr.ENTITY_ID ='ROOT' and x.QTR = 2 THEN '01-JUL-2022'
	  WHEN hr_empmstr.ENTITY_ID ='PENS' and x.QTR = 2 THEN '01-JUL-2022'
	  ELSE 'TBD' 
	END as 'PaymentDate'
	,'' as 'ThirdPartySickPay'
	--,convert(varchar,x.QTREarnings_CD) as 'EarningCode'
	,ISNULL(Equiv_Earnings.EarnDesc,IIF(x.QTREarnings_CD = 0,'','Missing code '+convert(varchar,x.QTREarnings_CD))) as 'EarningCode'
	--,convert(varchar,x.QTRDeduct_CD) as 'DeductionCode'
	,ISNULL(Equiv_Deductions.DeductDesc ,IIF(x.QTRDeduct_CD = 0,'','Missing code '+convert(varchar,x.QTRDeduct_CD))) as 'DeductionCode'
	,x.QTRAmount as 'Amount'
	,'' as 'TaxableWages'
	,'' as 'SubjectWages'
	,'' as 'GrossWages'
	,'' as 'SupplementalWages'
	,'' as 'WithholdingOrder-CaseNumber'
	,'' as 'PayrollStateTaxAuthority'
	,'' as 'PayrollLocalCountyTaxAuthorityCode'
	,'' as 'PayrollLocalCityTaxAuthorityCode'
	,'' as 'PayrollLocalHomeSchoolDistrictTaxAuthorityCode'
	,'' as 'PayrollLocalOtherTaxAuthorityCode'
	,'' as 'FlexiblePaymentDeductionWorktag'
	,'' as 'CustomWorktag#1'
	,'' as 'CustomWorktag#2'
	,'' as 'CustomWorktag#3'
	,'' as 'CustomWorktag#4'
	,'' as 'CustomWorktag#5'
	,'' as 'CustomWorktag#6'
	,'' as 'CustomWorktag#7'
	,'' as 'CustomWorktag#8'
	,'' as 'CustomWorktag#9'
	,'' as 'CustomWorktag#10'
	,'' as 'RelatedCalculationID'
	,'' as 'RelatedCalcInputValue'
 
from [production_finance].[dbo].[hr_empmstr] 
		right join [production_finance].[dbo].[hr_emppay] 
     on hr_empmstr.id = hr_emppay.id and hr_emppay.unique_id = (select max(unique_id) from [production_finance].[dbo].[hr_emppay] where hr_empmstr.id = hr_emppay.id)
		right join (
		SELECT
			xtdQ1.HR_PE_ID as ID
			,xtdQ1.pyx_yy as PayYear
			,1 as QTR
			--,xtdQ1.pyx_no as LineItem
			,iif(pyx_no between 5000 and 5999,pyx_no,'') as QTREarnings_CD
			,iif((pyx_no between 1000 and 1999 OR pyx_no between 2000 and 2999) ,pyx_no,'') as QTRDeduct_CD
			,pyx_qtd01/100 as QTRAmount
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
			,pyx_qtd02/100 as QTRAmount
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
			,pyx_qtd03/100 as QTRAmount
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
			,pyx_qtd04/100 as QTRAmount
		FROM
			[production_finance].[dbo].[pyx_xtd_dtl] xtdQ4
		WHERE (xtdQ4.pyx_no between 5000 and 5999 
				OR xtdQ4.pyx_no between 1000 and 1999 
				OR xtdQ4.pyx_no between 2000 and 2999)
				and xtdQ4.pyx_yy = 2022
				and xtdQ4.pyx_qtd04 > 0
				--and ehr.ID = xtdQ4.HR_PE_ID
		) x on hr_empmstr.ID = x.ID
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Earnings ON x.QTREarnings_CD = Equiv_Earnings.code
		LEFT JOIN [IT.Macomb_DBA].dbo.Equiv_Deductions ON x.QTRDeduct_CD = Equiv_Deductions.code
--		where  hr_empmstr.ID = 'E003542' -- testing
		WHERE hr_empmstr.entity_id in ('ROOT')
		and x.QTREarnings_CD not in ('5919','3919')
order by 1