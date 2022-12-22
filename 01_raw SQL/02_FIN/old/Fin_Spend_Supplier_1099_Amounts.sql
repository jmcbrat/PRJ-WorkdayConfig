/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_1099_Amounts
*/
SELECT
 trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,'' as '1099Amount'
,'C0001' as 'Company'
,'' as 'IRS1099FormType'
,'' as 'AdjustmentDate'
,isnull(SpendCat.WDSpendCategory,oh_dtl.OH_GL_OBJ) /*, use crosswalk fow WD value*/ as 'SpendCategory'

from [production_finance].[dbo].[pe_name_mstr]
RIGHT JOIN [production_finance].[dbo].oh_dtl
	ON pe_name_mstr.pe_id = oh_dtl.oh_pe_id
RIGHT JOIN [production_finance].[dbo].glk_key_mstr
	ON oh_dtl.oh_gl_key = glk_key_mstr.glk_key
RIGHT JOIN [IT.Macomb_DBA].[dbo].CrosswalksObjecttoLedgerCd_SpendCat SpendCat
	ON oh_dtl.OH_GL_OBJ = SpendCat.ONESolutionObject

JOIN [production_finance].[dbo].[pe_vendor_dtl]
	ON oh_dtl.oh_pe_id = pe_vendor_dtl.pe_id

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
AND vend_1099_flag = 'Y'
order by 1

/*
 -- to see if Vendor is 1099 list
--Then use glt_trns_dtl.glt_pe_id
--glt_trns_dtl.glt_dr and glt_cr
--Sum by year
*/