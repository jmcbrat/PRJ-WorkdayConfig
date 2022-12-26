/*HR_Override Balances*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Absence_Template_half Mapped' as Spreadsheet
,'Override Balances' as TabName
,'HR_Override Balances' as QueryName
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
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_emppay]  ON hr_empmstr.id = hr_emppay.id
    AND hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
  RIGHT JOIN [production_finance].[dbo].pyx_xtd_dtl 
  ON hr_empmstr.id = pyx_xtd_dtl.hr_pe_id
  AND pyx_xtd_dtl.PYX_YY = '2022'
  /*AND pyx_xtd_dtl.pyx_no in ('7007','7008','7010','7014','7037','7038')*/
  AND pyx_xtd_dtl.pyx_no in ('7007','7010','7014','7038','7008','7037')
  AND pyx_xtd_dtl.PYX_CTD>0
  right JOIN (SELECT p.hr_pe_id, sum(p.pyx_CTD) as pyx_CTD
  FROM [production_finance].[dbo].pyx_xtd_dtl p
  WHERE p.pyx_no in ('7008','7037') AND p.PYX_YY = '2022'
  GROUP BY p.hr_pe_id) z 
  ON hr_empmstr.id = z.hr_pe_id
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 /* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_emppay]  ON hr_empmstr.id = hr_emppay.id
    AND hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
  RIGHT JOIN [production_finance].[dbo].pyx_xtd_dtl 
  ON hr_empmstr.id = pyx_xtd_dtl.hr_pe_id
  AND pyx_xtd_dtl.PYX_YY = '2022'
  /*AND pyx_xtd_dtl.pyx_no in ('7007','7008','7010','7014','7037','7038')*/
  AND pyx_xtd_dtl.pyx_no in ('7007','7010','7014','7038','7008','7037')
  AND pyx_xtd_dtl.PYX_CTD>0
  right JOIN (SELECT p.hr_pe_id, sum(p.pyx_CTD) as pyx_CTD
  FROM [production_finance].[dbo].pyx_xtd_dtl p
  WHERE p.pyx_no in ('7008','7037') AND p.PYX_YY = '2022'
  GROUP BY p.hr_pe_id) z 
  ON hr_empmstr.id = z.hr_pe_id
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 /* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




select
hr_empmstr.id as 'WorkerID'
,'Denise Krzeminski' as 'SourceSystem'
,'' as 'PositionID'
,CASE
  WHEN pyx_xtd_dtl.pyx_NO = '7007' and HR_empmstr.hr2 = 'Drop' THEN 'DROP PTO Time Off Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7007' and HR_empmstr.hr2 is null THEN 'PTO Time Off Plan' 
  --WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037')  THEN 'Sick_Time_Off_Plan'
  WHEN pyx_xtd_dtl.pyx_NO =  '7008' THEN 'Sick Time Off Plan'
  WHEN pyx_xtd_dtl.pyx_NO =  '7037' THEN 'Sick Time Off Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' THEN 'Personal Business-Time Off Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7014' THEN 'Compensatory-Time Off Plan'
  WHEN pyx_xtd_dtl.pyx_NO = '7038' THEN 'Covid-19 - Time Off Plan'
  ELSE HR_empmstr.hr2 --convert(varchar,pyx_xtd_dtl.pyx_NO)
  END as 'TimeOffPlanID'
,'02-APR-2022' as 'OverrideBalanceDate'
,IIF(pyx_xtd_dtl.pyx_NO in ('7008','7037')
	,convert(numeric(12,2),convert(numeric(12,2),z.pyx_CTD)/100000)
	,convert(numeric(12,2),convert(numeric(12,2),pyx_xtd_dtl.pyx_CTD)/100000)) as 'OverrideBalanceUnits'
,'' as 'Comments'
/*,CASE
  WHEN HR_empmstr. hr2= 'Drop' THEN '1/1/2022' 
  WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037') 
       AND HR_empmstr. hr2= 'Drop' THEN '1/1/2022'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' 
       AND hr_empmstr.bargunit in ('01','07','20','26') THEN '1/1/2022' 
  ELSE ''
 END */
 ,'' as 'CarryoverDate'
/*,CASE
  WHEN HR_empmstr. hr2= 'Drop' THEN '12/31/2022' 
  WHEN pyx_xtd_dtl.pyx_NO in ('7008','7037') 
       AND HR_empmstr. hr2= 'Drop' THEN '12/31/2022'
  WHEN pyx_xtd_dtl.pyx_NO = '7010' 
       AND hr_empmstr.bargunit in ('01','07','20','26') THEN '12/31/2022' 
  ELSE ''
 END*/ 
 ,''as 'CarryoverExpirationDate'
/*,CASE 
 WHEN hr_empmstr.hr2 = 'Drop' THEN (hr_emppay.actl_hrs * 260) * hr_empmstr.numb2
 WHEN hr_empmstr.hr2 = 'Drop' THEN  hr_emppay.actl_hrs * 6
 WHEN hr_empmstr.bargunit in ('01','07','20','26') THEN 16
ELSE 0
END */
,'' as 'CarryoverOverrideBalanceUnits'
/*,'---hr_empmstr---'
,hr_empmstr.* 
,'---hr_emppay---'
,hr_emppay.*
,'---pyx_xtd_dtl---'
,pyx_xtd_dtl.**/
FROM 	  [production_finance].[dbo].[hr_empmstr]
  RIGHT JOIN [production_finance].[dbo].[hr_emppay]  ON hr_empmstr.id = hr_emppay.id
    AND hr_emppay.pay_beg = (select max(e2.pay_beg) from [production_finance].[dbo].[hr_emppay] e2 where hr_empmstr.id = e2.id)
  RIGHT JOIN [production_finance].[dbo].pyx_xtd_dtl 
  ON hr_empmstr.id = pyx_xtd_dtl.hr_pe_id
  AND pyx_xtd_dtl.PYX_YY = '2022'
  /*AND pyx_xtd_dtl.pyx_no in ('7007','7008','7010','7014','7037','7038')*/
  AND pyx_xtd_dtl.pyx_no in ('7007','7010','7014','7038','7008','7037')
  AND pyx_xtd_dtl.PYX_CTD>0
  right JOIN (SELECT p.hr_pe_id, sum(p.pyx_CTD) as pyx_CTD
  FROM [production_finance].[dbo].pyx_xtd_dtl p
  WHERE p.pyx_no in ('7008','7037') AND p.PYX_YY = '2022'
  GROUP BY p.hr_pe_id) z 
  ON hr_empmstr.id = z.hr_pe_id
where 
 hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 --and hr_empmstr.id = 'E003542'

order by 1