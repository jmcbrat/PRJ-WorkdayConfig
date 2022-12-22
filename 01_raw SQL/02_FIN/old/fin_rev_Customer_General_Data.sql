/*fin rev Customer General Data*/
/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_Sean_10032022.xlsx]
TabName: Customer_General_Data
*/
SELECT
ar_pe_mstr.arp_pe_id as 'CustomerID'
,'Steve and Bill' as 'SourceSystem'
,ar_pe_mstr.arp_pe_id as 'CustomerReferenceID'
,ar_pe_mstr.ARP_PE_NAME as 'CustomerName'
,'Legacy' as 'CustomerCategory'
,'' as 'CustomerGroup#1'
,'' as 'CustomerGroup#2'
,'' as 'CustomerGroup#3'
,'' as 'CustomerGroup#4'
,'' as 'CustomerGroup#5'
,'Immediate' as 'PaymentTerms'
--,arpa_link_dtl.armp_term as 'PaymentTerms'
,ar_trns_dtl.ar_pay_type as 'DefaultPaymentType'
,'USD' as 'DefaultCurrencyCode'
,'' as 'DefaultTaxCode'
,'' as 'TaxIDType'
,'' as 'TaxID_1'
,'' as 'TransactionTaxID'
,'' as 'PrimaryTaxID'
,'' as 'TaxStatusCountryCode'
,'' as 'TransactionTaxStatus'
,'' as 'WithholdingTaxStatus'
,'' as 'TaxIDType2'
,'' as 'TaxID_2'
,'' as 'TransactionTaxID2'
,'' as 'PrimaryTaxID2'
,'' as 'TaxStatusCountryCode2'
,'' as 'TransactionTaxStatus2'
,'' as 'WithholdingTaxStatus2'
,'' as 'TaxIDType3'
,'' as 'TaxID_3'
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
,'' as 'Worktag-8_Industry'
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


from [production_finance].[dbo].[ar_pe_mstr]
 --left JOIN [production_finance].[dbo].ar_ref_mstr /* [production_finance].[dbo].ar_trans_dtl*/
 --ON ar_pe_mstr.ARP_PE_ID = ar_ref_mstr.arr_ref
 RIGHT JOIN [production_finance].[dbo].ar_trns_dtl
 ON ar_pe_mstr.ARP_PE_ID = ar_trns_dtl.art_cust_id
 --RIGHT JOIN [production_finance].[dbo].arpa_link_dtl
 -- ON ar_pe_mstr.ARP_PE_ID = arpa_link_dtl.ARPA_PE_ID
/*where left(ar_cust_mstr.ara_cust_id,1) in ('V','C')
  AND */
/*  ar_pe_mstr.ARP_PE_ID in (select distinct oh_pe_id
	FROM [production_finance].[dbo].oh_dtl
	RIGHT JOIN [production_finance].[dbo].[pe_name_mstr]
	  ON  oh_dtl.oh_pe_id = pe_name_mstr.pe_id
	RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	  ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
	where oh_dtl.oh_ck_dt between case
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
		WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
	END and getdate())*/
order by 1	

/*
D department
C Customer
V Customer
E Employee
P Public works
Z non ar cash
S
T
W
J
*/
--ar_trans_dtl. 


/*select * from [production_finance].[dbo].ar_trns_dtl
ar_trns_dtl.ar_ref_dt
ar_ref_mstr.ar_ref_dt

and ara_cust_id in (
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

-- Invoiced 

select * from [production_finance].[dbo].[ar_cust_mstr]*/