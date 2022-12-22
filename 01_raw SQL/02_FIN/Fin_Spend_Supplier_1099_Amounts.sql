/*
Macomb_Spend_Template_Sean_V1.xlsx]
TabName: Supplier_1099_Amounts
*/

select oh_dtl.oh_pe_id as id, sum(glt_trns_dtl.glt_dr) + sum(glt_trns_dtl.glt_cr) as amt, isnull(SpendCat.WDSpendCategory,oh_dtl.OH_GL_OBJ) as spendCat
into #tempAggregate
from [production_finance].[dbo].oh_dtl
JOIN [production_finance].[dbo].[glt_trns_dtl]
	ON glt_trns_dtl.glt_pe_id = oh_dtl.oh_pe_id
	AND glt_trns_dtl.glt_gl_key = oh_dtl.oh_gl_key
	AND glt_trns_dtl.glt_gl_obj = oh_dtl.oh_gl_obj	
JOIN [production_finance].[dbo].[pe_vendor_dtl]
	ON oh_dtl.oh_pe_id = pe_vendor_dtl.pe_id
JOIN [IT.Macomb_DBA].[dbo].CrosswalksObjecttoLedgerCd_SpendCat SpendCat
	ON oh_dtl.OH_GL_OBJ = SpendCat.ONESolutionObject
WHERE glt_trns_dtl.glt_date between '2022-01-01' and getdate()
AND pe_vendor_dtl.vend_1099_flag = 'Y'
and left(pe_vendor_dtl.pe_id, 1) not in ('J', 'W','T')
group by oh_dtl.oh_pe_id, isnull(SpendCat.WDSpendCategory,oh_dtl.OH_GL_OBJ)
order by 1, 3;

select
 t.id as 'SupplierReferenceID'
,'"Steve Smigiel, Lynne Lapierre"' as 'SourceSystem'
,t.amt as '1099Amount'
,'C0001' as 'Company'
,case when vend_1099_dflt is null or trim(vend_1099_dflt) = '' or trim(vend_1099_dflt) = 'CC' then '1099-NEC' else '1099-MISC' end as 'IRS1099FormType'
,case when p.UPDATE_WHEN is null
then RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, p.CREATE_WHEN)), 2) + '-' +  UPPER(FORMAT(p.CREATE_WHEN, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, p.CREATE_WHEN))
else RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, p.UPDATE_WHEN)), 2) + '-' +  UPPER(FORMAT(p.UPDATE_WHEN, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, p.UPDATE_WHEN))
end as 'AdjustmentDate'
,t.spendCat as 'Spend Category'
from #tempAggregate t
join [production_finance].[dbo].[pe_vendor_dtl] p
	ON t.id = p.pe_id
--where isnumeric(trim(t.spendcat)) = 1 --koaSteven: no spendCat mapped
order by vend_1099_dflt

drop table #tempAggregate
go


/*
--koaSteven: missing spendCat
select *
from [IT.Macomb_DBA].[dbo].CrosswalksObjecttoLedgerCd_SpendCat
--where ONESolutionObject = '60735'
where ONESolutionObject in (
'12619','26810','35900','40401','40403','40406','40501','45302','45304','60735','61899','63301','63302','63303','63308','65501','69999','95134'
)
*/

