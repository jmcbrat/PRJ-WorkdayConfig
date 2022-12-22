/*
Macomb_Spend_Template_Sean_V1
TabName: Supplier_Open_Invoices_Detailed
-- as Sean about the linked images
*/
SELECT
trim(pe_name_mstr.pe_id) as 'SupplierInvoiceID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,oh_dtl.oh_ref as 'InvoiceNumber'
,'C0001' as 'CompanyOrganization'
,'USD' as 'CurrencyCode'
,'' as 'CurrencyRateTypeOverride'
,'' as 'CurrencyRateDateOverride'
,'' as 'CurrencyRateManualOverride'
,trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
,'' as 'Remit-ToSupplierConnection'
,oh_dtl.OH_REF as 'SupplierInvoiceNumber'
,oh_dtl.oh_ref_dt as 'InvoiceDate'
,'' as 'DueDateOverride'
,'' as 'AccountingDateOverride'
,'Immediate' as 'PaymentTerms'
,'' as 'OnHold'
,'' as 'Prepaid'
,'' as 'PrepaidAmortizationType'
,'' as 'FreightAmount'
,'' as 'OtherCharges'
,'' as 'ControlTotalAmount'
,'' as 'TaxOption'
,'' as 'TaxAmount'
,'' as 'TaxCode'
,'' as 'ExternalPONumber'
,'' as 'ExternalSupplierInvoiceSource'
,'' as 'AdditionalReferenceType'
,oh_dtl.OH_SEC_REF as 'AdditionalReferenceNumber'
,'' as 'LockedInWorkday'
,'' as 'Memo'
,'' as 'SupplierInvoiceLineOrder'
,'C0001' as 'LineCompanyOrganization'
--,isnull(SpendCat.WDSpendCategory,oh_dtl.OH_GL_OBJ) as 'SpendCategory'
,'' as 'PurchaseItem'
,'' as 'ItemDescription'
,'' as 'TaxApplicability'
,convert(varchar,convert(decimal(10,2),oh_dtl.OH_UNIT_PRICE)) as 'UnitPrice'
,oh_dtl.OH_UNITS as 'Quantity'
,oh_dtl.OH_DIST_AMT as 'ExtendedAmount'
,'' as 'FileName'
/* removed worktags for now based on 12/1 call with Alight */
--,isnull(WDCostCenter,oh_dtl.OH_GL_KEY) /*then find Primary part 7 for crosswalk*/ as 'Worktag-1'
,'' as 'Worktag-1'
--,isnull(SpendCat.WDSpendCategory,oh_dtl.OH_GL_OBJ) as 'Worktag-2'
,'' 'Worktag-2'
--,isnull(WDFundID,oh_dtl.OH_GL_KEY) /*glk_key_mstr.GLK_sel_code01 *//* then find Primary part 1 for crosswalk*/ as 'Worktag-3'
,'' as 'Worktag-3'
,'' as 'Worktag-4'
,'' as 'Worktag-5'
,'' as 'Worktag-6'
,'' as 'Worktag-7'
,'' as 'Worktag-8'
,'' as 'Worktag-9'
,'' as 'Worktag-10'
,'' as 'Worktag-11'
,'' as 'Worktag-12'
,'' as 'Worktag-13'
,'' as 'Worktag-14'
,'' as 'Worktag-15'

from [production_finance].[dbo].[pe_name_mstr]
RIGHT JOIN [production_finance].[dbo].oh_dtl
	ON pe_name_mstr.pe_id = oh_dtl.oh_pe_id
RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
RIGHT JOIN [production_finance].[dbo].[glt_trns_dtl]
	ON glk_key_mstr.glk_key = glt_trns_dtl.glt_gl_key
/*
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsOrgKey_WdFund] Worktag1
	ON glk_key_mstr.glk_key = Worktag1.OsOrgKey
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsOrgKey_WdCostCenter] Worktag2
	ON  glk_key_mstr.glk_key = Worktag2.OsOrgKey
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsObjCd_WdSpendCat] Worktag3
	ON  glt_trns_dtl.GLT_GL_OBJ = Worktag3.OsObjCode
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsObjCd_WdRevCat] Worktag4
	ON  glt_trns_dtl.GLT_GL_OBJ = Worktag4.OsObjCode
*/
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

/*
--select top 10 * from [production_finance].[dbo].glk_key_mstr
select convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101) --2020-12-31
select convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101) --2021-06-30
select convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101) --2021-09-30
*/