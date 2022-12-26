/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx
TabName: Customer_Phone_Number
*/
select
 trim(ar_cust_mstr.ara_cust_id) as 'CustomerID'
,'ONESolution' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id) as 'SortOrder'
,iif(ROW_NUMBER() OVER (PARTITION BY ar_cust_mstr.ara_cust_id ORDER BY ar_cust_mstr.ara_cust_id)=1,'Y','N') as 'Primary'
,'USA' as 'CountryISOCode'
,1 as 'InternationalPhoneCode'
,left(trim(pe_phone_dtl.phone_number),3) as 'AreaCode'
,right(trim(pe_phone_dtl.phone_number),7) as 'PhoneNumber'
,case when pe_phone_dtl.phone_type_cd in ('AR','EP','H1','P1','R1','  ') then 'Landline' when pe_phone_dtl.phone_type_cd = 'C1' then 'Mobile' when pe_phone_dtl.phone_type_cd = 'F1' then 'Fax' else 'Mobile' end as 'PhoneExtension'
,iif(pe_phone_dtl.phone_type_cd = 'R1','Y','N') as 'PhoneDeviceType'
,'Y' as 'Public'
,'' as 'UseForReference'
,'' as 'UseForReference2'
,'' as 'UseForReference3'
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
and len(trim(pe_phone_dtl.phone_number)) = 10
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
case 
	when pe_phone_dtl.phone_type_cd in ('AR','EP','H1','P1','R1','  ') then 'Landline'
	when pe_phone_dtl.phone_type_cd = 'C1' then 'Mobile'
	when pe_phone_dtl.phone_type_cd = 'F1' then 'Fax'
	else 'Mobile'
end as 'PhoneExtension'

case when pe_phone_dtl.phone_type_cd in ('AR','EP','H1','P1','R1','  ') then 'Landline'	when pe_phone_dtl.phone_type_cd = 'C1' then 'Mobile' when pe_phone_dtl.phone_type_cd = 'F1' then 'Fax' else 'Mobile' end as 'PhoneExtension'
*/
