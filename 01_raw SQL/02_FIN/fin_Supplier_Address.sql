/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_Address
*/


SELECT 
trim(pe_name_mstr.pe_id) as 'SupplierID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,ROW_NUMBER() OVER (ORDER BY pe_name_mstr.pe_id) as 'SortOrder'
,IIF(ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id)=1,'Y','N') as 'Primary'
,concat(trim(pe_name_mstr.pe_id),'-',convert(varchar,ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id))) as 'AddressID'
,'USA' /*pe_addr_dtl.pe_country_cd*/ as 'CountryISOCode'
,trim(pe_addr_dtl.pe_addr3) as 'AddressLine#1'
,trim(pe_addr_dtl.pe_addr1) as 'AddressLine#2'
,'' as 'AddressLine#3'
,'' as 'AddressLine#4'
,'' as 'AddressLine#5'
,'' as 'AddressLine#6'
,'' as 'AddressLine#7'
,'' as 'AddressLine#8'
,'' as 'AddressLine#9'
,trim(pe_addr_dtl.pe_city) as 'City'
,'' as 'CitySubdivision'
,'' as 'CitySubdivision2'
,case
   when trim(pe_addr_dtl.pe_state_cd) <> '' THEN 'USA-'+trim(pe_addr_dtl.pe_state_cd)
	else ''
	END as 'Region'
,'' as 'RegionSubdivision'
,'' as 'RegionSubdivision2'
,case
   when trim(pe_addr_dtl.pe_zip) = '00000' then '' 
	else trim(pe_addr_dtl.pe_zip) 
	end as 'PostalCode'
,'Y' as 'Public'
,'' as 'UseForReference'
,'' as 'UseForReference2'
,'' as 'UseForReference3'
,'' as 'UseForReference4'
,'' as 'AddressComment'


from [production_finance].[dbo].[pe_name_mstr]
	  right join [production_finance].[dbo].pe_email_dtl
	  on pe_name_mstr.pe_id = pe_email_dtl.PE_ID and pe_email_dtl.unique_id = (select max(x.unique_id) from [production_finance].[dbo].pe_email_dtl x where x.pe_id =  pe_name_mstr.pe_id group by x.PE_ID)
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id 
WHERE pe_name_mstr.PE_ID in (select distinct oh_pe_id
	FROM [production_finance].[dbo].oh_dtl
	RIGHT JOIN [production_finance].[dbo].[pe_name_mstr]
	  ON  oh_dtl.oh_pe_id = pe_name_mstr.pe_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	  ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
	where oh_dtl.oh_ck_dt between case
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END and getdate())
	AND pe_addr_dtl.pe_addr3 is not null
	AND pe_addr_dtl.pe_city is not null
	AND pe_addr_dtl.pe_state_cd is not null
	AND pe_addr_dtl.pe_ZIP <> '00000'
order by 1