/*
Macomb_Spend_Template_Sean_V1.xlsx]
TabName: Supplier_Entity_Contact_Name
*/
SELECT
trim(pe_name_mstr.pe_id) as 'SupplierContactID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,'' as 'SupplierReferenceID'
,'USA' as 'CountryISOCode-LegalName'
,'' as 'Prefix'
,'' as 'LegalFirstName'
,'' as 'LegalMiddleName'
,'' as 'LegalLastName'
,'' as 'Suffix'
from [production_finance].[dbo].[pe_name_mstr]

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