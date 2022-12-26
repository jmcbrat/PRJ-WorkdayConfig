/*HCM_BENEFITS_Additional_Benefits_Election*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_Benefits_Template_07052022 _jdm Questions.xlsx' as Spreadsheet
,'Additional Benefits Election' as TabName
,'HCM_BENEFITS_Additional_Benefits_Election' as QueryName
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
		RIGHT JOIN [production_finance].[dbo].hr_cdhassgn ON hr_empmstr.id = hr_cdhassgn.id
		  AND hr_cdhassgn.no in ('2419','2417','2418')
	WHERE hr_empmstr.Entity_id in ('ROOT','ROAD','PENS','ZINS')
	  AND hr_empmstr.hr_status = 'A'
/* end of grab */
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
	FROM [production_finance].[dbo].hr_empmstr
		RIGHT JOIN [production_finance].[dbo].hr_cdhassgn ON hr_empmstr.id = hr_cdhassgn.id
		  AND hr_cdhassgn.no in ('2419','2417','2418')
	WHERE hr_empmstr.Entity_id in ('ROOT','ROAD','PENS','ZINS')
	  AND hr_empmstr.hr_status = 'A'
/* end of grab */
) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;



SELECT
hr_empmstr.id as 'EmployeeID'
,'Jen Smiley' as 'SourceSystem'
,IIF(hr_cdhassgn.beg < convert(date,'1/1/2022')
   ,replace(convert(date,convert(date,'1/1/2022'),106),' ','-')
	,replace(convert(date,hr_cdhassgn.beg,106),' ','-')) as 'EventDate'
,'Conversion_Additional_Benefits' as 'BenefitEventType'
/*,Look at hr_cdhassgn.no (which is the cdh code which corresponds to the benefit and use that as the look up value for look up key below for plan name)*/
,CASE
  WHEN hr_cdhassgn.no = '2465' THEN 'PetInsurance'
  WHEN hr_cdhassgn.no = '2419' THEN 'Legal Shield'       /*needs correct code*/
  WHEN hr_cdhassgn.no = '2417' THEN 'Identity Theft'     /*needs correct code*/
  WHEN hr_cdhassgn.no = '2418' THEN 'Legal and ID'       /*needs correct code*/ 
  ELSE ''
  END as 'AdditionalBenefitsPlan'
,'' as 'AdditionalBenefitsCoverageTarget'
,replace(convert(date,hr_cdhassgn.beg,106),' ','-') as 'OriginalCoverageBeginDate'
FROM [production_finance].[dbo].hr_empmstr
	RIGHT JOIN [production_finance].[dbo].hr_cdhassgn ON hr_empmstr.id = hr_cdhassgn.id
	  AND hr_cdhassgn.no in ('2419','2417','2418')
WHERE hr_empmstr.Entity_id in ('ROOT','ROAD','PENS','ZINS')
  AND hr_empmstr.hr_status = 'A'