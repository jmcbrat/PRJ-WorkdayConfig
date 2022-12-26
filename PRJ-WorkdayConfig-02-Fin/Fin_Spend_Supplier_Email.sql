/*
Macomb_Spend_Template_Sean_V1]
TabName: Supplier_Email
*/


SELECT 
trim(pe_name_mstr.pe_id) as 'SupplierID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id) as 'SortOrder'
,IIF(ROW_NUMBER() OVER (PARTITION BY pe_name_mstr.pe_id ORDER BY pe_name_mstr.pe_id)=1,'Y','N') as 'Primary'
,CASE
 WHEN pe_email_dtl.email_addr not like '%@%' THEN ''
 ELSE trim(substring(pe_email_dtl.email_addr,1, iif(charindex(' ',pe_email_dtl.email_addr)>2,charindex(' ',pe_email_dtl.email_addr)-2,charindex(' ',pe_email_dtl.email_addr))))
 END as 'EmailAddress'
,CASE
 WHEN left(trim(pe_name_mstr.pe_id), 1) = 'E' THEN 'N'
 WHEN left(trim(pe_name_mstr.pe_id), 1) = 'V' and trim(pe_name_mstr.pe_affil_cd) = 'EMPL' THEN 'N'
 ELSE 'Y'
 END as 'Public'
,CASE 
 WHEN pe_email_dtl.email_type_cd = 'EP' THEN 'REMIT'
 WHEN pe_email_dtl.email_type_cd = 'PR' THEN 'MAILING'
 WHEN pe_email_dtl.email_type_cd = 'AR' THEN 'BILLING'
 ELSE ''
 END as 'UseForReference'

,'' as 'UseForReference2'
,'' as 'UseForReference3'
,'' as 'UseForReference4'
--,'------pe_assoc_dtl'
--,pe_assoc_dtl.*
from [production_finance].[dbo].[pe_name_mstr]
	  right join [production_finance].[dbo].pe_email_dtl
	  on trim(pe_name_mstr.pe_id) = pe_email_dtl.PE_ID and pe_email_dtl.unique_id = (select max(x.unique_id) from [production_finance].[dbo].pe_email_dtl x where x.pe_id =  pe_name_mstr.pe_id group by x.PE_ID)
left join pe_vendor_dtl
	on pe_email_dtl.pe_id = pe_vendor_dtl.pe_id
WHERE pe_name_mstr.PE_ID in (
	select distinct oh_pe_id
	FROM [production_finance].[dbo].oh_dtl
	RIGHT JOIN [production_finance].[dbo].[pe_name_mstr]
	  ON  oh_dtl.oh_pe_id = pe_name_mstr.pe_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	  ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
	where oh_dtl.oh_ck_dt between case
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END and getdate()
)

order by 1	
