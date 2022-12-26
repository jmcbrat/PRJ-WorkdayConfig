/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx
TabName: Customer_Address
*/
SELECT
 ar_cust_mstr.ara_cust_id as 'CustomerID'
,'ONESolution' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id) as 'SortOrder'
,IIF(ROW_NUMBER() OVER ( PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)=1,'Y','N') as 'Primary'
,concat(trim(ar_cust_mstr.ara_cust_id),'-',ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)) as 'AddressID'
,'USA' as 'CountryISOCode'
,CASE WHEN pe_addr_dtl.pe_addr3 is NOT null THEN trim(pe_addr_dtl.pe_addr3) WHEN pe_addr_dtl.pe_addr3 is null THEN Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')) ELSE '' END as 'AddressLine#1'
,CASE WHEN pe_addr_dtl.pe_addr3 is null AND LEFT(Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')),8) = 'P.O. BOX' THEN IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1)) WHEN len(trim(pe_addr_dtl.pe_addr1))>0 and len(Trim(pe_addr_dtl.pe_addr2))> 0 THEN trim(pe_addr_dtl.pe_addr1)+', '+Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')) ELSE IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1)) END as 'AddressLine#2'
,'' as 'AddressLine#3'
,'' as 'AddressLine#4'
,'' as 'AddressLine#5'
,'' as 'AddressLine#6'
,'' as 'AddressLine#7'
,'' as 'AddressLine#8'
,'' as 'AddressLine#9'
,case
   when ar_cust_mstr.ara_cust_id = 'V06729' THEN 'MT Clemens'
	else trim(pe_addr_dtl.pe_city) 
	END as 'City'
,'' as 'CitySubdivision'
,'' as 'CitySubdivision2'
,case
   when ar_cust_mstr.ara_cust_id = 'V06729' THEN 'USA-MI'
	ELSE 'USA-'+trim(pe_addr_dtl.pe_state_cd) 
	END as 'Region'
,'' as 'RegionSubdivision'
,'' as 'RegionSubdivision2'
,case 
    when ar_cust_mstr.ara_cust_id = 'V06729' THEN '49047' 
	 ELSE trim(pe_addr_dtl.pe_zip) 
	 END as 'PostalCode'
,'Y' as 'Public'
,'' as 'UseForReference'
,'' as 'UseForReference2'
,'' as 'UseForReference3'
,'' as 'UseForReference4'
from [production_finance].[dbo].[ar_cust_mstr]
right join [production_finance].[dbo].pe_name_mstr
	on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
right join [production_finance].[dbo].pe_addr_dtl
	on pe_name_mstr.pe_id = pe_addr_dtl.pe_id
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
and NOT (pe_addr_dtl.pe_addr2 is null and pe_addr_dtl.pe_addr3 is null)
and trim(pe_addr_dtl.pe_zip) <>''
and ar_cust_mstr.ara_cust_id in (
	SELECT DISTINCT ara_cust_id
	FROM [production_finance].[dbo].ar_trns_dtl trns_dtl
	RIGHT JOIN [production_finance].[dbo].[ar_cust_mstr] cust_mstr
		ON  trns_dtl.art_cust_id = cust_mstr.ara_cust_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr glk
		ON trns_dtl.ar_gl_key = glk.glk_key
	WHERE trns_dtl.ar_post_dt BETWEEN CASE
		WHEN glk.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END AND getdate()
)
order by 1,3



/*
,'USA' as 'R-CountryISOCode'
--,IIF(isnull(pe_addr_dtl.pe_country_cd,'')='' or pe_addr_dtl.pe_country_cd='Null' or pe_addr_dtl.pe_country_cd='','USA',trim(pe_addr_dtl.pe_country_cd)) as 'R-CountryISOCode'
,CASE
  WHEN pe_addr_dtl.pe_addr3 is NOT null THEN trim(pe_addr_dtl.pe_addr3) 
  WHEN pe_addr_dtl.pe_addr3 is null THEN Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX'))
  ELSE ''
  END as 'O-AddressLine#1'
--CASE WHEN pe_addr_dtl.pe_addr3 is NOT null THEN trim(pe_addr_dtl.pe_addr3) WHEN pe_addr_dtl.pe_addr3 is null THEN Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')) ELSE '' END
,CASE
  WHEN pe_addr_dtl.pe_addr3 is null AND LEFT(Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')),8) = 'P.O. BOX' 
     THEN IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1))
  WHEN len(trim(pe_addr_dtl.pe_addr1))>0 and len(Trim(pe_addr_dtl.pe_addr2))> 0
     THEN trim(pe_addr_dtl.pe_addr1)+', '+Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX'))
  ELSE IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1))
  END  as 'O-AddressLine#2'
--CASE WHEN pe_addr_dtl.pe_addr3 is null AND LEFT(Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')),8) = 'P.O. BOX' THEN IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1)) WHEN len(trim(pe_addr_dtl.pe_addr1))>0 and len(Trim(pe_addr_dtl.pe_addr2))> 0 THEN trim(pe_addr_dtl.pe_addr1)+', '+Trim(replace(replace(pe_addr_dtl.pe_addr2,'PO BOX','P.O. BOX'),'P O BOX', 'P.O. BOX')) ELSE IIF(trim(pe_addr_dtl.pe_addr1) is null,'',trim(pe_addr_dtl.pe_addr1)) END
*/

