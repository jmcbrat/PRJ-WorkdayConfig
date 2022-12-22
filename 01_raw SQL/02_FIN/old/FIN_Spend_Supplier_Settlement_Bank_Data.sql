/*
Macomb_Spend_Template_Sean_V1.xlsx]
TabName: Supplier_Settlement_Bank_Data
*/
SELECT
trim(pe_name_mstr.pe_id) as 'SupplierReferenceID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,ROW_NUMBER() OVER (ORDER BY pe_name_mstr.pe_id) as 'SortOrder'
,concat('Settlement_Account','_',convert(varchar,ROW_NUMBER() OVER (ORDER BY pe_name_mstr.pe_id))) as 'BankAccountReferenceID-SettlementAccount'
,'USA' as 'CountryISOCode-SettlementAccount'
,'USD' as 'CurrencyCode-SettlementAccount'
,CASE WHEN pe_vendor_dtl.bank_type = 'C' THEN 'DDA' WHEN pe_vendor_dtl.bank_type = 'S' THEN 'SA' ELSE '' END as 'AccountType-SettlementAccount'
,isnull(trim(pe_vendor_dtl.bank_route), '') as 'BankIDNumber-SettlementAccount'
,trim(pe_vendor_dtl.bank_acct) as 'BankAccountNumber-SettlementAccount'
,0 as 'CheckDigit-SettlementAccount'
,0 as 'NameonAccount-SettlementAccount'
,0 as 'BankAccountNickname-SettlementAccount'
,case
   when trim(pe_vendor_dtl.bank_route) is null or trim(pe_vendor_dtl.bank_route) = '' then ''
   when trim(bankName.NameofBank) is null or trim(bankName.NameofBank) = '' then ''
   else trim(bankName.NameofBank)
 end as 'BankName-SettlementAccount'
,0 as 'BranchID-SettlementAccount'
,0 as 'BranchName-SettlementAccount'
,0 as 'RollNumber-SettlementAccount'
,0 as 'IBAN-SettlementAccount'
,0 as 'SWIFTBankIdentificationCode-SettlementAccount'
,CASE WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK' WHEN pe_vendor_dtl.payment_type= 'EFT' THEN 'EFT' ELSE '' END as 'PaymentType-SettlementAccount'
,0 as 'PaymentType#2-SettlementAccount'
,CASE WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK' WHEN pe_vendor_dtl.payment_type= 'EFT' THEN 'EFT' ELSE '' END as 'PaymentType#3-SettlementAccount'
,CASE WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK' WHEN pe_vendor_dtl.payment_type= 'EFT' THEN 'EFT' ELSE '' END as 'PaymentType#4-SettlementAccount'
,CASE WHEN pe_vendor_dtl.payment_type = 'CHK' THEN 'CHECK' WHEN pe_vendor_dtl.payment_type= 'EFT' THEN 'EFT' ELSE '' END as 'PaymentType#5-SettlementAccount'
,CASE WHEN pe_vendor_dtl.payment_type= 'CHK' THEN 'N' WHEN pe_vendor_dtl.payment_type= 'EFT' THEN 'Y' ELSE '' END as 'RequiresPrenote-SettlementAccount'
,0 as 'PaymentTypeforPrenote-SettlementAccount'
,0 as 'BankInstructions-SettlementAccount'

from [production_finance].[dbo].[pe_name_mstr]
right join [production_finance].[dbo].pe_vendor_dtl
	on pe_name_mstr.pe_id = pe_vendor_dtl.pe_id and pe_vendor_dtl.bank_type in ('S','C')
right join [production_finance].[dbo].pe_addr_dtl
	on pe_name_mstr.pe_id = pe_addr_dtl.PE_ID and pe_addr_dtl.pe_addr_cd = '01'
left outer join  [IT.Macomb_DBA].[dbo].[EFTVendorsBankName] bankName
	on trim(pe_vendor_dtl.bank_route) = trim(bankName.RoutingNumber)
	and trim(pe_name_mstr.pe_id) = trim(bankName.peid)
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
AND left(trim(pe_name_mstr.pe_id), 1) not in ('J','W','T')
order by 1


/*
select *
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]
*/
