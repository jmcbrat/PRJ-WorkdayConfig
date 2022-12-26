/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_General_Data
*/

SELECT 
trim(pe_name_mstr.pe_id) as 'SupplierID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
,trim(pe_name_mstr.pe_name) as 'SupplierName'
,trim(pe_name_mstr.pe_id_status) as 'SubmitSupplier'
,'' as 'CreateSupplierFromBusinessEntityType'
,'' as 'CreateSupplierFromBusinessEntity'
,'Professional_Services' as 'SupplierCategory'
,'' as 'SupplierGroup#1'
,'' as 'SupplierGroup#2'
,'' as 'SupplierGroup#3'
,'' as 'SupplierGroup#4'
,'' as 'SupplierGroup#5'
,'' as 'DefaultSpendCategory'
/*
,CASE
  WHEN pe_vendor_dtl.vend_1099_dflt = 'CC' THEN '1099_MISC' -- Should be '1099-NEC'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'AF' THEN '1099_MISC'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'MH' THEN '1099_MISC'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'OI' THEN '1099_MISC'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'FE' THEN '1099_MISC'
  ELSE ''
  END  as 'TaxAuthorityFormType'
*/
--koaSteven 08dec22 - made consistent with 'Supplier 1099 Amounts' logic
,CASE
	WHEN pe_vendor_dtl.vend_1099_flag = 'Y' AND LEFT(pe_vendor_dtl.pe_id, 1) NOT IN ('J', 'W','T') THEN
		CASE
			WHEN pe_vendor_dtl.vend_1099_dflt IS NULL OR TRIM(pe_vendor_dtl.vend_1099_dflt) = '' OR TRIM(pe_vendor_dtl.vend_1099_dflt) = 'CC' THEN '1099-NEC'
			ELSE '1099-MISC'
		END
	ELSE ''
 END as 'TaxAuthorityFormType'
/*,CASE
  WHEN pe_vendor_dtl.vend_1099_dflt = 'CC' THEN 'Y' -- Should be 'N'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'AF' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'MH' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'OI' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'FE' THEN 'Y'
  ELSE 'N'
  END  as 'IRS1099Supplier'
*/
--koaSteven 08dec22 - made consistent with 'Supplier 1099 Amounts' logic
,IIF(pe_vendor_dtl.vend_1099_flag = 'Y' AND LEFT(pe_vendor_dtl.pe_id, 1) NOT IN ('J', 'W','T'), 'Y', 'N') as 'IRS1099Supplier'
/*,CASE
  WHEN pe_vendor_dtl.vend_1099_dflt = 'CC' THEN 'Y' -- Should be 'N'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'AF' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'MH' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'OI' THEN 'Y'
  WHEN pe_vendor_dtl.vend_1099_dflt = 'FE' THEN 'Y'
  ELSE 'N'
  END as 'Report1099withParent'
*/
--koaSteven 08dec22 - made consistent with 'Supplier 1099 Amounts' logic
,IIF(pe_vendor_dtl.vend_1099_flag = 'Y' AND LEFT(pe_vendor_dtl.pe_id, 1) NOT IN ('J', 'W','T'), 'Y', 'N') as 'Report1099withParent'
,IIF(pe_assoc_dtl.code_dt is null,'',replace(convert(varchar, pe_assoc_dtl.code_dt, 106),' ','-')) as 'TaxDocumentDate'
,'' as 'DefaultTaxCode'
,'' as 'DefaultWithholdingTaxCode'
,IIF(pe_vendor_dtl.tin is null or trim(pe_vendor_dtl.tin) = '','','USA-EIN') as 'TaxIDType1'
--,IIF(pe_vendor_dtl.tin is null or trim(pe_vendor_dtl.tin) = '','',concat(substring(convert(varchar,pe_vendor_dtl.tin),1,2),'-',substring(convert(varchar,pe_vendor_dtl.tin),3,7))) as 'TaxID#1'
--koaSteven 12dec22 - Assume we shouldn't provide TaxID for 1099 suppliers. See CNP833.
,CASE
	WHEN pe_vendor_dtl.vend_1099_flag = 'Y' AND LEFT(pe_vendor_dtl.pe_id, 1) NOT IN ('J', 'W','T') THEN '' 
	ELSE IIF(pe_vendor_dtl.tin is null or trim(pe_vendor_dtl.tin) = '','',concat(substring(convert(varchar,pe_vendor_dtl.tin),1,2),'-',substring(convert(varchar,pe_vendor_dtl.tin),3,7)))
END as 'TaxID#1'
--XX-XXXXXXX
--,pe_vendor_dtl.tin
,IIF(pe_vendor_dtl.tin is null or trim(pe_vendor_dtl.tin) = '','N','Y') as 'TransactionTaxID1'
,IIF(pe_vendor_dtl.tin is null or trim(pe_vendor_dtl.tin) = '','N','Y') as 'PrimaryTaxID1'
,''/*IIF(pe_name_mstr.pe_ssn is null or trim(pe_name_mstr.pe_ssn) = '','','USA-SSN')*/ as 'TaxIDType2'
,''/*IIF(pe_name_mstr.pe_ssn is null or trim(pe_name_mstr.pe_ssn) = '','',concat(substring(pe_name_mstr.pe_ssn,1,3),'-',substring(pe_name_mstr.pe_ssn,4,2),'-',substring(pe_name_mstr.pe_ssn,6,4)))*/ as 'TaxID#2'
,'' /*IIF(pe_vendor_dtl.tin is null,'Y','N')*/ as 'TransactionTaxID2'
,'' /*IIF(pe_name_mstr.pe_ssn is null or trim(pe_name_mstr.pe_ssn) = '','N','Y')*/ as 'PrimaryTaxID2'
,'' as 'TaxIDType3'
,'' as 'TaxID#3'
,'' as 'TransactionTaxID3'
,'' as 'PrimaryTaxID3'
,'' as 'TaxIDType4'
,'' as 'TaxID#4'
,'' as 'TransactionTaxID4'
,'' as 'PrimaryTaxID4'
,'' as 'TaxIDType5'
,'' as 'TaxID#5'
,'' as 'TransactionTaxID5'
,'' as 'PrimaryTaxID5'
,CASE 
  WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK'
  WHEN pe_vendor_dtl.payment_type = 'EFT' THEN 'EFT' 
  ELSE ''
  END as 'AcceptedPaymentType#1'
,CASE 
  WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK'
  WHEN pe_vendor_dtl.payment_type = 'EFT' THEN 'EFT' 
  ELSE ''
  END as 'AcceptedPaymentType#2'
,'' as 'AcceptedPaymentType#3'
,'' as 'AcceptedPaymentType#4'
,'' as 'AcceptedPaymentType#5'
,CASE 
  WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK'
  WHEN pe_vendor_dtl.payment_type = 'EFT' THEN 'EFT' 
  ELSE ''
  END as 'DefaultPaymentType'
,'Immediate' as 'PaymentTerms'
,'USD' as 'AcceptedCurrency#1'
,'' as 'AcceptedCurrency#2'
,'' as 'AcceptedCurrency#3'
,'' as 'AcceptedCurrency#4'
,'' as 'AcceptedCurrency#5'
,'USD' as 'DefaultCurrencyCode'
,'' as 'DefaultAdditionalType'
,'' as 'ProcurementCreditCard'
,'' as 'RemittanceIntegrationSystem'
,'N' as 'AlwaysSeparatePayments' --ohb_batch_dtl.oh_sep_check
,'' as 'TextforDefaultSupplierPaymentMemo' --ohb_batch_dtl.oh_desc
,'' as 'UseSupplierReferenceasDefaultSupplierPaymentMemo' --oh_bir_mstr.oh_ref
--,ohb_batch_dtl.oh_desc as 'O-TextforDefaultSupplierPaymentMemo'
--,oh_bir_mstr.oh_ref as 'O-UseSupplierReferenceasDefaultSupplierPaymentMemo'
,'Y' as 'UseSupplierConnectionMemo'
,'' as 'CertificateofInsuranceDate'
,'' as 'DUNSNumber'
,IIF(trim(pe_name_mstr.pe_sel_cd1) is null,'',trim(pe_name_mstr.pe_sel_cd1)) as 'CustomerAccountNumber'
,'' as 'PurchaseOrderIssueOption'
,'' as 'DefaultPOIssueEmail'
,'' as 'ShippingTerms'
/*,'------pe_assoc_dtl------'
,pe_assoc_dtl.* */
from [production_finance].[dbo].[pe_name_mstr]
     right join [production_finance].[dbo].pe_vendor_dtl
	  on pe_name_mstr.pe_id = pe_vendor_dtl.pe_id
	  left join [production_finance].[dbo].pe_assoc_dtl
	  on pe_name_mstr.pe_id = pe_assoc_dtl.PE_ID  and pe_assoc_dtl.unique_id = (select max(x.unique_id) from [production_finance].[dbo].pe_assoc_dtl x where x.pe_id =  pe_name_mstr.pe_id group by x.PE_ID)
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
and pe_name_mstr.PE_ID not like 'JR%' and pe_name_mstr.PE_ID not like 'W%' --CNP857/858

