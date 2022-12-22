/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_Entity_Contact_Phone
*/
SELECT
trim(pe_name_mstr.pe_id) as 'SupplierContactID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id) as 'SortOrder'
,IIF(ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id)=1,'Y','N') as 'Primary'
,'USA' as 'CountryISOCode'
,1 as 'InternationalPhoneCode'
,trim(pe_phone_dtl.phone_number)  as 'PhoneNumber'
,'' as 'PhoneExtension'
,case 
  when pe_phone_dtl.phone_type_cd in ('AR','EP','H1','P1','R1','  ') THEN 'Landline'
  when pe_phone_dtl.phone_type_cd = 'C1' THEN 'Mobile'
  when pe_phone_dtl.phone_type_cd = 'F1' THEN 'Fax'
  ELSE ''
  end as 'PhoneDeviceType'
,'Y' as 'Public'
,0 as 'UseForReference'
,0 as 'UseForReference2'
,0 as 'UseForReference3'
from [production_finance].[dbo].[pe_name_mstr]
	  right join [production_finance].[dbo].pe_phone_dtl
	  on pe_name_mstr.pe_id = pe_phone_dtl.pe_id 
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
order by 1