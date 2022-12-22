/*
Macomb_Procurement_Template_koaSteven.xlsx]
TabName: Receipts___Goods
*/
SELECT
 'REC_' + por_rec_dtl.por_item as 'ReceiptNumber'
,'"Dave Stiteler, Alex Ryder"' as 'SourceSystem'
,'C0001' as 'Company'
,por_rec_dtl.por_ref_no as 'SupplierReferenceID'
,RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, por_rec_dtl.por_dt)), 2) + '-' +  UPPER(FORMAT(por_rec_dtl.por_dt, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, por_rec_dtl.por_dt)) as 'DocumentDate'
,'' as 'Memo'
,ROW_NUMBER() OVER (PARTITION BY por_rec_dtl.por_ref_no ORDER BY por_rec_dtl.por_item) as 'LineOrder'
,ROW_NUMBER() OVER (PARTITION BY por_rec_dtl.por_ref_no ORDER BY por_rec_dtl.por_item) as 'PurchaseOrderLineID'
,'' as 'SupplierContractID'
,'' as 'SupplierContractLineID'
,'' as 'LineCompany'
,por_rec_dtl.por_item as 'PurchaseItem'
,por_rec_dtl.por_qty as 'Quantity'
,'' as 'UnitofMeasure'
,'' as 'DeliveryType'
,'' as 'LineMemo'
,isnull(por_rec_dtl.por_serial, '') as 'SerialIdentifier'

from pop_pv_dtl
join por_rec_dtl
	on pop_pv_dtl.pop_pr_no = por_rec_dtl.por_ref_no
where pop_pv_dtl.pop_status in ('PR','PO','PP')
and por_rec_dtl.por_type = 'R'
and trim(pop_pv_dtl.pop_po_no) <> ''
order by por_rec_dtl.por_ref_no, por_rec_dtl.por_item
