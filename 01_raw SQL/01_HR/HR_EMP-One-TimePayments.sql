/*HR_EMP-One-TimePayments*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Compensation_Template_Calculate Plan tab_Mapped.xlsx' as Spreadsheet
,'EMP-One-Time Payments' as TabName
,'HR_EMP-One-TimePayments' as QueryName
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
	  RIGHT JOIN (SELECT hr_pe_id, t.PYH_CK_NO, t.pyh_ck_dt, t.PYH_POST_DT
			  ,v.no
			  ,v.amt
			FROM [production_finance].[dbo].pyh_hst_dtl t
			CROSS APPLY (VALUES
			  (pyh_no01, pyh_amt01)
			  ,(pyh_no02, pyh_amt02)
			  ,(pyh_no03, pyh_amt03)
			  ,(pyh_no04, pyh_amt04)
			  ,(pyh_no05, pyh_amt05)
			  ,(pyh_no06, pyh_amt06)
			  ,(pyh_no07, pyh_amt07)
			  ,(pyh_no08, pyh_amt08)
			  ,(pyh_no09, pyh_amt09)
			  ,(pyh_no10, pyh_amt10)
			  ,(pyh_no11, pyh_amt11)
			  ,(pyh_no12, pyh_amt12)
			  ,(pyh_no13, pyh_amt13)
			  ,(pyh_no14, pyh_amt14)
			  ,(pyh_no15, pyh_amt15)
			) v(no, amt)
			where t.pyh_ck_dt between '01/01/2022' and '12/31/2022' /*and hr_pe_id = 'E001040' --testing only */
			  and v.no in ('3196','5599')) tz 
  ON hr_empmstr.id = tz.HR_PE_ID
where hr_empmstr.ENTITY_ID = 'ROOT'
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[hr_empmstr]
	  RIGHT JOIN (SELECT hr_pe_id, t.PYH_CK_NO, t.pyh_ck_dt, t.PYH_POST_DT
			  ,v.no
			  ,v.amt
			FROM [production_finance].[dbo].pyh_hst_dtl t
			CROSS APPLY (VALUES
			  (pyh_no01, pyh_amt01)
			  ,(pyh_no02, pyh_amt02)
			  ,(pyh_no03, pyh_amt03)
			  ,(pyh_no04, pyh_amt04)
			  ,(pyh_no05, pyh_amt05)
			  ,(pyh_no06, pyh_amt06)
			  ,(pyh_no07, pyh_amt07)
			  ,(pyh_no08, pyh_amt08)
			  ,(pyh_no09, pyh_amt09)
			  ,(pyh_no10, pyh_amt10)
			  ,(pyh_no11, pyh_amt11)
			  ,(pyh_no12, pyh_amt12)
			  ,(pyh_no13, pyh_amt13)
			  ,(pyh_no14, pyh_amt14)
			  ,(pyh_no15, pyh_amt15)
			) v(no, amt)
			where t.pyh_ck_dt between '01/01/2022' and '12/31/2022' /*and hr_pe_id = 'E001040' --testing only */
			  and v.no in ('3196','5599')) tz 
  ON hr_empmstr.id = tz.HR_PE_ID
where hr_empmstr.ENTITY_ID = 'ROOT'
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



select
trim(hr_empmstr.id) as 'EmployeeID'
,'Denise Krzeminski' as 'SourceSystem'
,IIF(hr_empmstr.enddt < tz.pyh_ck_dt
  ,replace(convert(varchar,hr_empmstr.enddt,106),' ','-')
  ,replace(convert(varchar,tz.pyh_ck_dt,106),' ','-')) as 'EffectiveDate'
,'' as 'PositionID'
,'Request_Compensation_Change_Conversion_Conversion' as 'One-TimePaymentReason'
,CASE
  WHEN tz.no = '3196' THEN 'Lump Sum'
  WHEN tz.no = '5599' THEN 'PTO Cash Out' 
  ELSE ''
  END as 'One-TimePaymentPlan'
,cast(IIF(tz.no = '3196'
          ,convert(DECIMAL(11,2),tz.amt)/100000
			 ,convert(DECIMAL(11,2),tz.amt)/100) as float) as 'One-TimePaymentAmount'
,'USD' as 'CurrencyCode'
from [production_finance].[dbo].[hr_empmstr]
	  RIGHT JOIN (SELECT hr_pe_id, t.PYH_CK_NO, t.pyh_ck_dt, t.PYH_POST_DT
			  ,v.no
			  ,v.amt
			FROM [production_finance].[dbo].pyh_hst_dtl t
			CROSS APPLY (VALUES
			  (pyh_no01, pyh_amt01)
			  ,(pyh_no02, pyh_amt02)
			  ,(pyh_no03, pyh_amt03)
			  ,(pyh_no04, pyh_amt04)
			  ,(pyh_no05, pyh_amt05)
			  ,(pyh_no06, pyh_amt06)
			  ,(pyh_no07, pyh_amt07)
			  ,(pyh_no08, pyh_amt08)
			  ,(pyh_no09, pyh_amt09)
			  ,(pyh_no10, pyh_amt10)
			  ,(pyh_no11, pyh_amt11)
			  ,(pyh_no12, pyh_amt12)
			  ,(pyh_no13, pyh_amt13)
			  ,(pyh_no14, pyh_amt14)
			  ,(pyh_no15, pyh_amt15)
			) v(no, amt)
			where t.pyh_ck_dt between '01/01/2022' and '12/31/2022' /*and hr_pe_id = 'E001040' --testing only */
			  and v.no in ('3196','5599')) tz 
  ON hr_empmstr.id = tz.HR_PE_ID
where hr_empmstr.ENTITY_ID = 'ROOT'
  AND (hr_empmstr.hr_status = 'A'
    OR (hr_empmstr.hr_status = 'I' AND hr_empmstr.ENDDT>'12/31/2021'
	 and hr_empmstr.termcode <> 'NVST'))
		order by 1;
