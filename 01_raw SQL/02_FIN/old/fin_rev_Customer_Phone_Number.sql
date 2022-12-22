/*fin rev Customer Phone Number*/
/*insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'FIN' as Spreadsheet
,'rev Customer Phone Number' as TabName
,'fin rev Customer Phone Number' as QueryName
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
from [production_finance].[dbo].[pe_name_mstr]
     right join [production_finance].[dbo].ar_cust_mstr
	  on pe_name_mstr.pe_id = ar_cust_mstr.ara_cust_id
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id 
	  right join [production_finance].[dbo].pe_phone_dtl
	  on pe_name_mstr.pe_id = pe_phone_dtl.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
and pe_addr_dtl.PE_ADDR_CD = pe_phone_dtl.PE_ADDR_CD
and pe_phone_dtl.phone_type_cd <>'  '
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
/* end of grab */ 
  GROUP BY hr_empmstr.Entity_id, hr_empmstr.hr_status
UNION ALL 
SELECT 'TotalRecords' AS ColName, Count(*) as CNT
/* from taken from the main query below*/
from [production_finance].[dbo].[pe_name_mstr]
     right join [production_finance].[dbo].ar_cust_mstr
	  on pe_name_mstr.pe_id = ar_cust_mstr.ara_cust_id
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id 
	  right join [production_finance].[dbo].pe_phone_dtl
	  on pe_name_mstr.pe_id = pe_phone_dtl.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
and pe_addr_dtl.PE_ADDR_CD = pe_phone_dtl.PE_ADDR_CD
and pe_phone_dtl.phone_type_cd <>'  '
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
/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;


*/



SELECT
trim(ar_cust_mstr.ara_cust_id) as 'R-CustomerID'
,'ONESolution' as 'O-SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id) as 'R-SortOrder'
,iif(ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)=1,'Y','N') as 'R-Primary'
,'USA' /*pe_addr_dtl.pe_country_cd*/ as 'R-CountryISOCode'
--,pe_phone_dtl.phone_type_cd
,1 as 'O-InternationalPhoneCode'
,trim(pe_phone_dtl.phone_number) as 'R-PhoneNumber'
,'' as 'O-PhoneExtension'
,case 
  when pe_phone_dtl.phone_type_cd = 'AR' THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = 'C1' THEN 'Mobile'
  when pe_phone_dtl.phone_type_cd = 'EP' THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = 'F1' THEN 'Fax'
  when pe_phone_dtl.phone_type_cd = 'H1' THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = 'P1' THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = 'R1' THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = '  ' THEN 'Landline'
  ELSE 'Mobile'
  end as 'R-PhoneDeviceType'
,iif(pe_phone_dtl.phone_type_cd = 'R1','Y','N') as 'R-Public'
,'' as 'O-UseForReference'
,'' as 'O-UseForReference2'
,'' as 'O-UseForReference3'
--,'----------'
--,pe_phone_dtl.*
--,'----------'
--,pe_addr_dtl.*
from [production_finance].[dbo].[pe_name_mstr]
     right join [production_finance].[dbo].ar_cust_mstr
	  on pe_name_mstr.pe_id = ar_cust_mstr.ara_cust_id
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id 
	  right join [production_finance].[dbo].pe_phone_dtl
	  on pe_name_mstr.pe_id = pe_phone_dtl.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
and pe_addr_dtl.PE_ADDR_CD = pe_phone_dtl.PE_ADDR_CD
and pe_phone_dtl.phone_type_cd <>'  '
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