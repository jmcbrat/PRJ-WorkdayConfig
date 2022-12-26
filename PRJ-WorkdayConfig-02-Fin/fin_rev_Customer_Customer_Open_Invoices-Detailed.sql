/*
Macomb_County_FIN_CNP_Revenue_Template_Customers_KoaSteven.xlsx]
TabName: Customer_Open_Invoices_Detailed
*/

declare @openArInv table (cust_id char(12), ref char(16), amt numeric(20,2))

insert into @openArInv
select 
 ar_trns_dtl.art_cust_id
,ar_trns_dtl.ar_ref
,sum(ar_trns_dtl.ar_dist_amt)
from ar_trns_dtl
join ar_cust_mstr
	on ar_cust_mstr.ara_cust_id = ar_trns_dtl.art_cust_id
where ar_cust_mstr.ara_bal <> 0
group by ar_trns_dtl.art_cust_id, ar_trns_dtl.ar_ref
having sum(ar_trns_dtl.ar_dist_amt) <> 0
order by ar_trns_dtl.art_cust_id, ar_trns_dtl.ar_ref


/*
--lookup columns
SELECT
 ar_trns_dtl.ar_ref as 'CustomerInvoiceID'
,ar_trns_dtl.art_cust_id as 'CustomerID'
,ar_trns_dtl.ar_ref as 'InvoiceNumber'
,RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, ar_trns_dtl.ar_ref_dt)), 2) + '-' +  UPPER(FORMAT(ar_trns_dtl.ar_ref_dt, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, ar_trns_dtl.ar_ref_dt)) as 'InvoiceDate'
,ar_trns_dtl.ar_dist_amt as 'ControlTotalAmount'
,ROW_NUMBER() OVER (PARTITION BY ar_trns_dtl.ar_ref ORDER BY ar_trns_dtl.ar_ref) as 'CustomerInvoiceLineOrder'
,ar_trns_dtl.ar_prin_amt as 'UnitPrice'
,ar_trns_dtl.ar_qty as 'Quantity'
,ar_trns_dtl.ar_orig_amt as 'LegacyOriginalInvoiceAmount'
*/

SELECT
 ar_trns_dtl.ar_ref as 'CustomerInvoiceID'
,'ONESolution' as 'SourceSystem'
,'C0001' as 'CompanyOrganization'
,'USD' as 'CurrencyCode'
,ar_trns_dtl.art_cust_id as 'CustomerID'
,ar_trns_dtl.ar_ref as 'InvoiceNumber'
,RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, ar_trns_dtl.ar_ref_dt)), 2) + '-' +  UPPER(FORMAT(ar_trns_dtl.ar_ref_dt, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, ar_trns_dtl.ar_ref_dt)) as 'InvoiceDate'
,'' as 'AccountingDateOverride'
,'' as 'DueDateOverride'
,'NET_30' as 'PaymentTerms'
,openArInv.amt as 'ControlTotalAmount' -- CNP814 fix (was ar_trns_dtl.ar_dist_amt)
,'' as 'PaymentType'
,'' as 'StatutoryInvoiceType'
,'' as 'CustomerInvoiceType'
,'' as 'BillableProjectID'
,'' as 'CurrencyRateTypeOverride'
,'' as 'CurrencyRateDateOverride'
,'' as 'CurrencyRateManualOverride'
,'N' as 'LockedInWorkday'
,'' as 'InterestandLateFeeExempt'
,'' as 'InvoiceMemo'
,ROW_NUMBER() OVER (PARTITION BY ar_trns_dtl.ar_ref ORDER BY ar_trns_dtl.ar_ref) as 'CustomerInvoiceLineOrder'
,'C0001' as 'LineCompanyOrganization'
,'' as 'RevenueCategory'
,'' as 'SalesItem'
,'' as 'SalesItemDescription'
,'' as 'TaxApplicability'
,'' as 'LineTaxCode'
,ar_trns_dtl.ar_prin_amt as 'UnitPrice'
,'' as 'CustomerContractLineID'
,ar_trns_dtl.ar_qty as 'Quantity'
,'' as 'LineTransactionDate'
,'' as 'LineProjectID'
,'' as 'AddressID'
,'' as 'CountryISOCode'
,'' as 'AddressLine#1'
,'' as 'AddressLine#2'
,'' as 'AddressLine#3'
,'' as 'AddressLine#4'
,'' as 'City'
,'' as 'Region'
,'' as 'PostalCode'
,ar_trns_dtl.ar_orig_amt as 'LegacyOriginalInvoiceAmount'
,'' as 'LegacyOriginalPaymentAmount'
,'' as 'Worktag-1'
,'' as 'Worktag-2'
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
from ar_trns_dtl
join @openArInv openArInv
	on ar_trns_dtl.art_cust_id = openArInv.cust_id
	and ar_trns_dtl.ar_ref = openArInv.ref

order by ar_trns_dtl.art_cust_id, ar_trns_dtl.ar_ref

