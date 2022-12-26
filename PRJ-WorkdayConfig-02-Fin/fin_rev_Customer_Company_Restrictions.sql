/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx
TabName: Customer_Company_Restrictions
*/
SELECT distinct
 ar_pe_mstr.arp_pe_id as 'CustomerID'
,'ONESolution' as 'SourceSystem'
,'GMS_USA' as 'RestrictedtoCompanyID'

FROM [production_finance].[dbo].[ar_pe_mstr]
JOIN [production_finance].[dbo].ar_trns_dtl
	 ON ar_pe_mstr.ARP_PE_ID = ar_trns_dtl.art_cust_id
WHERE ar_pe_mstr.arp_pe_id IN (
	SELECT DISTINCT art_cust_id
	FROM [production_finance].[dbo].ar_trns_dtl trns_dtl
	RIGHT JOIN [production_finance].[dbo].[ar_pe_mstr] pe_mstr
		ON  trns_dtl.art_cust_id = pe_mstr.arp_pe_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr glk
		ON trns_dtl.ar_gl_key = glk.glk_key
	-- sdk-koa: is POST DATE correct date to use for filter?
	WHERE trns_dtl.ar_post_dt BETWEEN CASE
		WHEN glk.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END AND getdate()
)
order by 1



