/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx
TabName: Customer_Email
*/
select 
 trim(ar_cust_mstr.ara_cust_id) as 'CustomerID'
,'ONESolution' as 'SourceSystem'
,ROW_NUMBER() OVER (PARTITION BY p.PE_ID ORDER BY RowID) as 'SortOrder'
,IIF(p.PrimaryEmail='Y','Y','N') as 'Primary'
,ltrim(trim(p.EmailAddress)) as 'EmailAddress'
,'Y' as 'Public'
,'' as 'UseForReference'
,'' as 'UseForReference2'
,'' as 'UseForReference3'

from [production_finance].[dbo].[ar_cust_mstr]
right join [production_finance].[dbo].pe_name_mstr
	on ar_cust_mstr.ara_cust_id = pe_name_mstr.pe_id
right join [IT.Macomb_DBA].[dbo].[fin_cust_email] p
	on pe_name_mstr.pe_id = p.PE_ID
where left(ar_cust_mstr.ara_cust_id,1) in ('V','D','C','Z','E')
AND ar_cust_mstr.ara_cust_id IN (
	SELECT DISTINCT art_cust_id
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
order by 1, 3

