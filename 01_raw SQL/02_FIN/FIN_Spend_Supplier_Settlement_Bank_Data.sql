/*
Macomb_Spend_Template_Sean_V1.xlsx]
TabName: Supplier_Settlement_Bank_Data
*/

if object_id(N'tempdb..#tempRouteNameMap') is not null
begin
drop table #tempRouteNameMap
end
go

select distinct trim(routingnumber) routeNum, trim(nameofbank) bkName
into #tempRouteNameMap
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]

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
,'' as 'CheckDigit-SettlementAccount'
,'' as 'NameonAccount-SettlementAccount'
,'' as 'BankAccountNickname-SettlementAccount'
,bk.bkName as 'BankName-SettlementAccount'
,'' as 'BranchID-SettlementAccount'
,'' as 'BranchName-SettlementAccount'
,'' as 'RollNumber-SettlementAccount'
,'' as 'IBAN-SettlementAccount'
,'' as 'SWIFTBankIdentificationCode-SettlementAccount'
,'EFT' as 'PaymentType-SettlementAccount'
,'' as 'PaymentType#2-SettlementAccount'
,'EFT' as 'PaymentType#3-SettlementAccount'
,'EFT' as 'PaymentType#4-SettlementAccount'
,'EFT' as 'PaymentType#5-SettlementAccount'
,'EFT' as 'RequiresPrenote-SettlementAccount'
,'' as 'PaymentTypeforPrenote-SettlementAccount'
,'' as 'BankInstructions-SettlementAccount'

from [production_finance].[dbo].[pe_name_mstr]
right join [production_finance].[dbo].pe_vendor_dtl
	on pe_name_mstr.pe_id = pe_vendor_dtl.pe_id and pe_vendor_dtl.bank_type in ('S','C')
right join [production_finance].[dbo].pe_addr_dtl
	on pe_name_mstr.pe_id = pe_addr_dtl.PE_ID and pe_addr_dtl.pe_addr_cd = '01'
join #tempRouteNameMap bk
	on trim(pe_vendor_dtl.bank_route) = bk.routeNum
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
AND pe_vendor_dtl.payment_type = 'EFT'
order by 1


/*
select count(*)
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]
where peid in ('E03646', 'V087077')

select distinct peid, routingnumber, count(*)
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]
group by peid, routingnumber

select distinct routingnumber, count(*)
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]
group by routingnumber

select distinct routingnumber, nameofbank--, count(*)
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]
group by routingnumber, nameofbank

select distinct routingnumber, nameofbank
into #tempRouteNameMap
from [IT.Macomb_DBA].[dbo].[EFTVendorsBankName]

select *
from #tempRouteNameMap
order by routingnumber

drop table #tempRouteNameMap

E03646 / 072000326
V087077 / 072000096
*/

