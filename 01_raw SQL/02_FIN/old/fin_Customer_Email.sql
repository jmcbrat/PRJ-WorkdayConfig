/*insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'FIN' as Spreadsheet
,'FIN_Customer_email' as TabName
,'Fin_Customer_Email' as QueryName
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
from [production_finance].[dbo].[ar_cust_mstr]
     right join [production_finance].[dbo].pe_name_mstr
	  on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
     right join fin_cust_email p
	  on pe_name_mstr.pe_id = p.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
--and ar_cust_mstr.ara_cust_id = 'V04997'
and ar_cust_mstr.ara_cust_id in (
'V04719',
'V05181',
'V04992',
'V00919',
'C00059',
'V00922',
'V05926',
'V00924',
'V00926',
'V05184',
'V00927',
'V05003',
'V00929',
'V00930');

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[ar_cust_mstr]
     right join [production_finance].[dbo].pe_name_mstr
	  on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
     right join fin_cust_email p
	  on pe_name_mstr.pe_id = p.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
--and ar_cust_mstr.ara_cust_id = 'V04997'
and ar_cust_mstr.ara_cust_id in (
'V04719',
'V05181',
'V04992',
'V00919',
'C00059',
'V00922',
'V05926',
'V00924',
'V00926',
'V05184',
'V00927',
'V05003',
'V00929',
'V00930');

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;

  */



select 
trim(ar_cust_mstr.ara_cust_id) as 'R-CustomerID'
,'ONESolution' as 'O-SourceSystem'
,'' as 'R-SortOrder'
,IIF(ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)=1,'Y','N') as 'R-Primary'
,ltrim(trim(p.email)) as 'R-EmailAddress'
,'Y' as 'R-Public'
,'' as 'O-UseForReference'
,'' as 'O-UseForReference2'
,'' as 'O-UseForReference3'
from [production_finance].[dbo].[ar_cust_mstr]
     right join [production_finance].[dbo].pe_name_mstr
	  on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
     right join fin_cust_email p
	  on pe_name_mstr.pe_id = p.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
--and ar_cust_mstr.ara_cust_id = 'V04997'
and ar_cust_mstr.ara_cust_id in (
'V04719',
'V05181',
'V04992',
'V00919',
'C00059',
'V00922',
'V05926',
'V00924',
'V00926',
'V05184',
'V00927',
'V05003',
'V00929',
'V00930');
