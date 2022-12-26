/*HCM_BENEFITS_Spending_Account_Elections*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Benefits_Template_07052022 _jdm Questions.xlsx' as Spreadsheet
,'Spending Account Elections' as TabName
,'HCM_BENEFITS_Spending_Account_Elections' as QueryName
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
FROM [production_finance].[dbo].hr_empmstr
   RIGHT JOIN [production_finance].[dbo].hr_tsainfo ON hr_empmstr.id = hr_tsainfo.id 
	AND hr_tsainfo.no in ('2328','2329','2326','2327')
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'  /*  end first union */
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL /*totals */
select 
'TotalRecords' as ColName
, count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].hr_empmstr
   RIGHT JOIN [production_finance].[dbo].hr_tsainfo ON hr_empmstr.id = hr_tsainfo.id 
	AND hr_tsainfo.no in ('2328','2329','2326','2327')
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'  /* End of second grab*/
) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;




SELECT
trim(hr_empmstr.id ) as 'EmployeeID'
,'Jen Smiley' as 'SourceSystem'
,CASE
  WHEN hr_empmstr.hdt > '12/31/2021' THEN hr_empmstr.hdt
  WHEN hr_tsainfo.beg < convert(datetime,'01/01/2022') THEN replace(convert(date,convert(date,'1/1/2022'),106),' ','-')
  WHEN hr_tsainfo.beg >= '1/1/2022' THEN replace(convert(date,hr_tsainfo.beg,106),' ','-')
  ELSE ''
  END  as 'EventDate'
,'Conversion_Spending_Account' as 'BenefitEventType'
,CASE 
  WHEN hr_tsainfo.no in ('2329','2327') THEN 'HCFSA'
  WHEN hr_tsainfo.no in ('2328','2326') THEN 'DCFSA'
  ELSE ''
  END as 'SpendingAccountPlan'
,0 as 'YTDContributionAmount' -- isnt this 9 * HR_tsainfo.amt for most employees
,HR_tsainfo.amt*26  as 'AnnualContribution'
,HR_tsainfo.amt as 'EmployeeCost'
,(26-9) as 'BenefitDeductionPeriodsRemaining'
,'Biweekly' as 'RemainingPeriodFrequency'
,'' as 'OriginalCoverageBeginDate'  /* intentially blank? */
FROM [production_finance].[dbo].hr_empmstr
   RIGHT JOIN [production_finance].[dbo].hr_tsainfo ON hr_empmstr.id = hr_tsainfo.id 
	AND hr_tsainfo.no in ('2328','2329','2326','2327')
WHERE hr_empmstr.Entity_id in ('ROOT','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'
 -- and hr_empmstr.id = 'E003542'

  order by 1
