/*EMP-system-accounts*/
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'USA_Macomb_HCM_CNP_HCM_Template_Mapped.xlsx' as Spreadsheet
,'EMP-System User Accounts' as TabName
,'EMP-system-accounts' as QueryName
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
	  LEFT JOIN [IT.Macomb_DBA].[dbo].[OneSolution_AD_account] as x
	  on trim(hr_empmstr.id) = x.id
	  and x.Delete_Flag is null
where hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 AND x.ad IS NOT NULL
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
FROM [production_finance].[dbo].[hr_empmstr]
	  LEFT JOIN [IT.Macomb_DBA].[dbo].[OneSolution_AD_account] as x
	  on trim(hr_empmstr.id) = x.id
	  and x.Delete_Flag is null
where hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 AND x.ad IS NOT NULL
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;





SELECT 
trim(hr_empmstr.id) as 'EmployeeID'
,IIF(trim(x.[Assumed Name]) = trim(x.[ID]), 'M-IT','C-IT') as 'SourceSystem'
,x.ad as 'UserName'
,'' as 'Password'
,'' as 'ExemptfromDelegatedAuthentication'
,'' as 'OpenIDConnectInternalIdentifier'
, '' as 'UserLanguage'
FROM [production_finance].[dbo].[hr_empmstr]
	  LEFT JOIN [IT.Macomb_DBA].[dbo].[OneSolution_AD_account] as x
	  on trim(hr_empmstr.id) = x.id
	  and x.Delete_Flag is null
where hr_empmstr.hr_status = 'A'
 and hr_empmstr.ENTITY_ID in ('ROOT','ROAD')
 AND x.ad IS NOT NULL
/* and hr_empmstr.id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) */
/* Rows 2526 */


order by 1

/*select * from [IT.Macomb_DBA].[dbo].[OneSolution_AD_account]
WHERE id in (
'E003844', /* - Denise*/
'E006056', /*- Tom*/
'E003770', /*- Anne*/
'E006082', /*- Arlene*/
'E003542', /*- Joe*/
'E021079' /*- Thida*/
) 
*/