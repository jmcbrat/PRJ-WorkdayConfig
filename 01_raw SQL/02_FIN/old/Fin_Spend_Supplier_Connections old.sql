/*
Macomb_Spend_Template_Sean_9302022.xlsx]
TabName: Supplier_Connections
*/
SELECT
trim(pe_name_mstr.pe_id) as 'SupplierConnectionID'
,pe_name_mstr.PE_NAME as 'SupplierConnectionName'
,'Steve Smigiel, Lynne Lapierre' as 'SourceSystem'
,pe_name_mstr.pe_id as 'SupplierReferenceID'
,'' as 'RemitToSupplier'
,'' as 'AddressID'
,'' as 'SettlementBankAccountID'
,'' as 'AlternateName#1'
,'' as 'AlternateName#2'
,'' as 'EmailAddress'
,'USD' as 'DefaultCurrency'
,'Immediate' as 'DefaultPaymentTerms'
,'' as 'AcceptedPaymentType_1'
,'' as 'AcceptedPaymentType_2'
,'' as 'AcceptedPaymentType_3'
,'Check' as 'DefaultPaymentType_1'
,'' as 'PaymentMemo'
,'' as 'IsDefault'
from [production_finance].[dbo].[pe_name_mstr]
	  right join [production_finance].[dbo].pe_email_dtl
	  on pe_name_mstr.pe_id = pe_email_dtl.PE_ID and pe_email_dtl.unique_id = (select max(x.unique_id) from [production_finance].[dbo].pe_email_dtl x where x.pe_id =  pe_name_mstr.pe_id group by x.PE_ID)
	  right join [production_finance].[dbo].pe_addr_dtl
	  on pe_name_mstr.pe_id = pe_addr_dtl.pe_id 
WHERE pe_name_mstr.PE_ID in (select distinct oh_pe_id
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

--12/31/2021

--org key left 3 is fund.


/*select * from glk_key_mstr
where glk_key in 
('10113101'  
,'13688604'  
,'13688604'  
,'13688604'  
,'14088604'  
,'22464657'  
,'22464626'  
,'22464639'  
,'22464640'  
,'90000000')  

select * from [production_finance].[dbo].[pe_name_mstr]
select * from [production_finance].[dbo].pe_vendor_dtl
select * from [production_finance].[dbo].pe_assoc_dtl
select * from [production_finance].[dbo].ohb_batch_dtl -- oh_gl_key
*/
/*
10113101  
13688604  
13688604  
13688604  
14088604  
22464657  
22464626  
22464639  
22464640  
90000000  */


--