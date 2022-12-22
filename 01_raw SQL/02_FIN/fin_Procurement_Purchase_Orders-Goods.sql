/*
Macomb_Procurement_Template_koaSteven.xlsx]
TabName: Purchase_Orders___Goods
*/
SELECT
 pop_pv_dtl.pop_po_no as 'PurchaseOrderID'
,'"Dave Stiteler, Alex Ryder"' as 'SourceSystem'
,pop_pv_dtl.pop_pr_no as 'DocumentNumber'
,'' as 'InvoiceStatus'
,pop_pv_dtl.pop_status as 'PaymentStatus'
,'' as 'ReceivingStatus'
,'' as 'ShippingStatus'
,'' as 'TrackingStatus'
,CASE
	WHEN trim(pop_pv_dtl.pop_req_codes08) = 'YF' THEN 'Macomb County Community Mental Health'
	WHEN trim(pop_pv_dtl.pop_req_codes08) = 'YW' THEN 'Martha T Berry Medical Care Facility'
	WHEN trim(pop_pv_dtl.pop_req_codes08) = 'ZE' THEN 'Drainage Districts'
	WHEN trim(pop_pv_dtl.pop_req_codes08) = 'ZK' THEN 'Macomb County Community Mental Health'
	WHEN trim(pop_pv_dtl.pop_req_codes08) = 'ZN' THEN 'Macomb St. Clair Workforce Development Board'
	ELSE 'Macomb County'
 END as 'Company'
,pop_pv_dtl.pop_pe_id as 'SupplierReferenceID'
,iif(pop_pv_dtl.pop_print_dt is null, '', RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, pop_pv_dtl.pop_print_dt)), 2) + '-' +  UPPER(FORMAT(pop_pv_dtl.pop_print_dt, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, pop_pv_dtl.pop_print_dt))) as 'DocumentDate'
,'' as 'TaxAmount'
,'' as 'FreightAmount'
,'' as 'OtherCharges'
,iif(trim(pop_pv_dtl.pop_terms) <> '', replace(trim(pop_pv_dtl.pop_terms),' ','_'), '') as 'PaymentTerms'
,'' as 'DueDate'
,'' as 'SupplierContractID'
,'External' as 'IssueOption'
,iif(trim(pop_pv_dtl.pop_buyer) <> '', pop_pv_dtl.pop_buyer, '') as 'Buyer'
,'' as 'OrderFromSupplierConnection'
,pop_pv_dtl.pop_bill_id as 'BillToContact'
,pop_pv_dtl.pop_ship_id as 'ShipToContact'
,'' as 'ProcedureDate'
,'' as 'Procedure'
,'' as 'ProcedureNumber'
,'' as 'PatientID'
,'' as 'MedicalRecordNumber'
,'' as 'PhysicianID'
,'' as 'VerifiedBy'
,'' as 'SupplierRepresentative'
,'' as 'AdditionalProcedureData'
,iif(poi_item_dtl.poi_po_item is null
    , trim(pop_pv_dtl.pop_po_no) 
/*	       + '-' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER (PARTITION BY oh_dtl.oh_pe_id ORDER BY oh_dtl.oh_pe_id))) + cast(ROW_NUMBER() OVER (PARTITION BY oh_dtl.oh_pe_id ORDER BY oh_dtl.oh_pe_id) as varchar)
*/			 + '-' + REPLICATE('0', 4 - LEN(ROW_NUMBER() OVER (PARTITION BY pop_pv_dtl.pop_po_no ORDER BY pop_pv_dtl.pop_po_no))) + cast(ROW_NUMBER() OVER (PARTITION BY pop_pv_dtl.pop_po_no ORDER BY pop_pv_dtl.pop_po_no) as varchar)
	 , trim(pop_pv_dtl.pop_po_no) 
	       + '-' + poi_item_dtl.poi_po_item
			 + '-' + REPLICATE('0', 2 - LEN(ROW_NUMBER() OVER (PARTITION BY trim(pop_pv_dtl.pop_po_no) + '-' + poi_item_dtl.poi_po_item ORDER BY trim(pop_pv_dtl.pop_po_no) + '-' + poi_item_dtl.poi_po_item))) + cast(ROW_NUMBER() OVER (PARTITION BY trim(pop_pv_dtl.pop_po_no) + '-' + poi_item_dtl.poi_po_item ORDER BY trim(pop_pv_dtl.pop_po_no) + '-' + poi_item_dtl.poi_po_item) as varchar)
			 ) 
as 'PurchaseOrderLineID'
,'' as 'LineCompany'
,iif(trim(poi_item_dtl.poi_com_cd) <> '', 'Catalog Item', '') as 'ItemType'
,iif(trim(poi_item_dtl.poi_com_cd) <> '', poi_item_dtl.poi_com_cd, '') as 'ItemID'
,pot_text_dtl.pot_text as 'ItemDescription'
,iif(trim(oh_dtl.oh_status) <> '', oh_dtl.oh_status, '') as 'LineInvoiceStatus'
,iif(trim(oh_dtl.oh_status) <> '', oh_dtl.oh_status, '') as 'LinePaymentStatus'
,'' as 'LineReceivingStatus'
,'' as 'LineShippingStatus'
,'' as 'LineTrackingStatus'
,isnull(CW1.WDSpendCategory,'OFFICE') as 'SpendCategory'
,'' as 'TaxApplicability'
,'' as 'TaxCode'
,poi_item_dtl.poi_amt as 'UnitPrice'
,case
   when poi_item_dtl.poi_units is null then 'EA'
	else poi_item_dtl.poi_units
	end as 'UnitofMeasure'
,poi_item_dtl.poi_qty as 'Quantity'
,poi_item_dtl.poi_amt * poi_item_dtl.poi_qty as 'ExtendedAmount'
,'' as 'GoodsDueDate'
,'' as 'Memo'
,'' as 'Worktag-1'
,'' as 'Worktag-2'
,'' as 'Worktag-3'
,'' as 'Worktag-4'
,'' as 'Worktag-5'

from pop_pv_dtl
join poi_item_dtl
	on pop_pv_dtl.pop_po_no = poi_item_dtl.poi_po_no and poi_item_dtl.poi_qty <>0
join pot_text_dtl
	on poi_item_dtl.poi_pr_no = pot_text_dtl.pot_ref_pr_no
	and poi_item_dtl.poi_ref_item_no = pot_text_dtl.pot_ref_item_no
left join oh_dtl
	on poi_item_dtl.poi_pr_no = oh_dtl.oh_pr_no
	and poi_item_dtl.poi_ref_item_no = oh_dtl.oh_pr_item
LEFT JOIN [it.macomb_dba].[dbo].[CrosswalksObjecttoLedgerCd_SpendCat] CW1
	ON poi_item_dtl.poi_gl_obj = CW1.ONESolutionObject
where pop_pv_dtl.pop_status in ('PR','PO','PP')
and trim(pop_pv_dtl.pop_po_no) <> ''
and pot_text_dtl.pot_type = '01' and pot_text_dtl.pot_seq_no = '00'

/* koaSteven: CNP817 (Supplier Reference ID) - This subselect is taken from the WHERE clause in FIN_Supplier_General_Data.sql which limits 
   the vendor list to those that have had a transaction in the given period, as determined by defined fiscal year end per GL acct. This 
   should limit vendors to those provided in 'supplier general data', per Alight 'Resolution Action During Conversion' on CNP817.
   NOTE: It might be best to implement this as a View as it's used in multiple scripts.
*/
and pop_pv_dtl.pop_pe_id in (
	SELECT distinct trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
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
		END and getdate())
)
order by 1,poi_item_dtl.poi_ref_item_no

/*
notes:
I - 'Company' -- crosswalk?
J - 'Supplier Reference ID' -- crosswalk?
K - 'Document Date' -- ckg for null and repl w/ ''
O - 'Payment Terms' -- ckg for null and repl w/ ''
S - 'Buyer- -- crosswalk to HCM???  also ckg for null and repl w/ ''
AF - 'Purchase Order Line ID' -- massaging for null poi_item_dtl.poi_po_item -- building padded ascending over distinct PO# for nulls
AI - 'Item ID' -- ckg for null and repl w/ ''
AJ - 'Item Description' -- grabbing only first line of item description for now (pot_text_dtl.pot_seq_no = '00')
AM - 'Line Recieving' -- leaving blank for now. optional? complex query? needs research.
*/

/*
--missing or bad WD Company values - pop_pv_dtl.pop_req_codes08

select pop_po_no, pop_req_codes08
from pop_pv_dtl

where pop_pv_dtl.pop_status in ('PR','PO','PP')
and trim(pop_pv_dtl.pop_po_no) <> ''
and pop_pv_dtl.pop_pe_id in (
	SELECT distinct trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
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
		END and getdate())
)
and (trim(pop_req_codes08) in ('AM','UP') OR pop_req_codes08 is null)
order by 2, 1
*/
