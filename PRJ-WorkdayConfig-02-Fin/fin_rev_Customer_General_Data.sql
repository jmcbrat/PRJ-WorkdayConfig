/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx]
TabName: Customer_General_Data
*/
SELECT distinct
ar_pe_mstr.arp_pe_id as 'CustomerID'
,'ONESolution' as 'SourceSystem'
,ar_pe_mstr.arp_pe_id as 'CustomerReferenceID'
,ar_pe_mstr.ARP_PE_NAME as 'CustomerName'
,'Legacy' as 'CustomerCategory'
,'' as 'CustomerGroup#1'
,'' as 'CustomerGroup#2'
,'' as 'CustomerGroup#3'
,'' as 'CustomerGroup#4'
,'' as 'CustomerGroup#5'
,'NET_30' as 'PaymentTerms'
,'Check' as 'DefaultPaymentType'
,'USD' as 'DefaultCurrencyCode'
,'' as 'DefaultTaxCode'
,'' as 'TaxIDType'
,'' as 'TaxID#'
,'' as 'TransactionTaxID'
,'' as 'PrimaryTaxID'
,'' as 'TaxStatusCountryCode'
,'' as 'TransactionTaxStatus'
,'' as 'WithholdingTaxStatus'
,'' as 'TaxIDType2'
,'' as 'TaxID#2'
,'' as 'TransactionTaxID2'
,'' as 'PrimaryTaxID2'
,'' as 'TaxStatusCountryCode2'
,'' as 'TransactionTaxStatus2'
,'' as 'WithholdingTaxStatus2'
,'' as 'TaxIDType3'
,'' as 'TaxID#3'
,'' as 'TransactionTaxID3'
,'' as 'PrimaryTaxID3'
,'' as 'TaxStatusCountryCode3'
,'' as 'TransactionTaxStatus3'
,'' as 'WithholdingTaxStatus3'
,'' as 'RemitFromCustomer'
,'' as 'DUNSNumber'
,'' as 'CreditLimitCurrencyCode'
,'' as 'CreditLimit'
,'' as 'CreditVerificationDate'
,'' as 'Worktag-1'
,'' as 'Worktag-2'
,'' as 'Worktag-3'
,'' as 'Worktag-4'
,'' as 'Worktag-5'
,'' as 'Worktag-6'
,'' as 'Worktag-7'
,'' as 'Worktag-8(Industry)'
,'' as 'Worktag-9'
,'' as 'Worktag-10'
,'' as 'Worktag-11'
,'' as 'Worktag-12'
,'' as 'Worktag-13'
,'' as 'Worktag-14'
,'' as 'Worktag-15'
,'' as 'Worktag-16'
,'' as 'Worktag-17'
,'' as 'Worktag-18'
,'' as 'Worktag-19'
,'' as 'Worktag-20'
,'' as 'Worktag-21'
,'' as 'Worktag-22'
,'' as 'Worktag-23'
,'' as 'Worktag-24'
,'' as 'Worktag-25'

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
	WHERE trns_dtl.ar_post_dt BETWEEN CASE
		WHEN glk.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END AND getdate()
)
order by 1



