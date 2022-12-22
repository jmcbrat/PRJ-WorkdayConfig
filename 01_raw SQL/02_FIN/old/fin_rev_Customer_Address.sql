/*fin rev Customer Address*/
/* insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'fin' as Spreadsheet
,'rev Customer Address' as TabName
,'fin rev Customer Address' as QueryName
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
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
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
'V00930')
and NOT (pe_addr_dtl.pe_addr2 is null and pe_addr_dtl.pe_addr3 is null)
and trim(pe_addr_dtl.pe_zip) <>''

/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[ar_cust_mstr]
     right join [production_finance].[dbo].pe_name_mstr
	  on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
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
'V00930')
and NOT (pe_addr_dtl.pe_addr2 is null and pe_addr_dtl.pe_addr3 is null)
and trim(pe_addr_dtl.pe_zip) <>''

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
,ROW_NUMBER() OVER  (ORDER BY ar_cust_mstr.ara_cust_id) as 'R-SortOrder'
,IIF(ROW_NUMBER() OVER ( ORDER BY ar_cust_mstr.ara_cust_id)=1,'Y','N') as 'R-Primary'
,concat(trim(ar_cust_mstr.ara_cust_id),'-',ROW_NUMBER() OVER  (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)) as 'O-AddressID'
,IIF(isnull(pe_addr_dtl.pe_country_cd,'')='' or pe_addr_dtl.pe_country_cd='Null' or pe_addr_dtl.pe_country_cd='','USA',trim(pe_addr_dtl.pe_country_cd)) as 'R-CountryISOCode'
,CASE
  WHEN pe_addr_dtl.pe_addr3 is NOT null THEN trim(pe_addr_dtl.pe_addr3) 
  WHEN pe_addr_dtl.pe_addr3 is null THEN Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX'))
  ELSE ''
  END as 'O-AddressLine#1'
,CASE
  WHEN pe_addr_dtl.pe_addr3 is null AND LEFT(Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')),8) = 'P.O. BOX' 
     THEN IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1))
  WHEN len(trim(pe_addr_dtl.pe_addr1))>0 and len(Trim(pe_addr_dtl.pe_addr2))> 0
     THEN trim(pe_addr_dtl.pe_addr1)+', '+Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX'))
  ELSE IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1))
  END  as 'O-AddressLine#2'
/*,IIF(len(trim(pe_addr_dtl.pe_addr1))>0,
    IIF(LEN(Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')))>0,
	      trim(pe_addr_dtl.pe_addr1)+', '+Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')),
	      trim(pe_addr_dtl.pe_addr1)),'') as 'O-AddressLine#2'
*/
,'' as 'O-AddressLine#3'
,'' as 'O-AddressLine#4'
,'' as 'O-AddressLine#5'
,'' as 'O-AddressLine#6'
,'' as 'O-AddressLine#7'
,'' as 'O-AddressLine#8'
,'' as 'O-AddressLine#9'
,TRIM(pe_addr_dtl.pe_city) as 'O-City'
,'' as 'O-CitySubdivision'
,'' as 'O-CitySubdivision2'
,'USA-'+TRIM(pe_addr_dtl.pe_state_cd) as 'O-Region'
,'' as 'O-RegionSubdivision'
,'' as 'O-RegionSubdivision2'
,Trim(pe_addr_dtl.pe_zip) as 'O-PostalCode'
,'Y' as 'R-Public'
,'Billing' as 'O-UseForReference'
,'Billing' as 'O-UseForReference2'
,'Billing' as 'O-UseForReference3'
,'Billing' as 'O-UseForReference4'
from [production_finance].[dbo].[ar_cust_mstr]
     right join [production_finance].[dbo].pe_name_mstr
	  on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
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
'V00930')
and NOT (pe_addr_dtl.pe_addr2 is null and pe_addr_dtl.pe_addr3 is null)
and trim(pe_addr_dtl.pe_zip) <>''
