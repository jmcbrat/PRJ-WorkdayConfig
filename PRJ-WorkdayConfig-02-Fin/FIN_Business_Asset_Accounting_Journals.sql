/*
Macomb_Accounting_Template_Business Asset_V1Sean]
TabName: Accounting_Journals
*/
SELECT --top 5000
 glt_trns_dtl.glt_batch_id as 'AccountingJournalID'
,'"Dave Stiteler, Alex Ryder"' as 'SourceSystem'
,'' as 'JournalNumber'
,'C0001' as 'CompanyOrganization-AccountingJournal'
,'USD' as 'CurrencyCode-AccountingJournal'
,'Actuals' as 'LedgerType'
,'' as 'BookCode'
,RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(DAY, glt_trns_dtl.glt_date)), 2) + '-' +  UPPER(FORMAT(glt_trns_dtl.glt_date, 'MMM', 'en-US')) + '-' +  CONVERT(VARCHAR(4), DATEPART(yy, glt_trns_dtl.glt_date)) as 'AccountingDate'
,'' as 'CreateReversal'
,'' as 'ReversalDate'
,'Manual_Journal' as 'JournalSource'
,glt_trns_dtl.glt_subs_id as 'JournalEntryMemo'
,glt_trns_dtl.glt_gl_key as 'ExternalReferenceID'
,'' as 'AdjustmentJournal'
,'' as 'BalancingWorktag'
,ROW_NUMBER() OVER (PARTITION BY glt_trns_dtl.glt_batch_id ORDER BY glt_trns_dtl.glt_batch_id) as 'LineOrder'
,'' as 'CompanyOrganization-JournalLine'
,isnull(WdLedger.WdLedgerAcctID, '') as 'LedgerAccountReference'
,isnull(WdLedger.WdLedgerAcctType, '') as 'LedgerAccountSet'
,'' as 'AlternateLedgerAccountReference'
,'' as 'AlternateLedgerAccountSet'
,glt_trns_dtl.glt_dr as 'DebitAmount'
,glt_trns_dtl.glt_cr as 'CreditAmount'
,'USD' as 'LineCurrencyCode'
,glt_trns_dtl.glt_dr as 'LedgerDebitAmount'
,glt_trns_dtl.glt_cr as 'LedgerCreditAmount'
,'' as 'Quantity'
,'' as 'UnitofMeasure'
,'' as 'Quantity#2'
,'' as 'UnitofMeasure#2'
,glt_trns_dtl.glt_desc as 'Memo'
,'' as 'JournalLineExternalReferenceID'
,isnull(Worktag1.WdFundID,'') as 'Worktag-1'
,isnull(Worktag2.WdCostCenter,'') as 'Worktag-2'
,isnull(Worktag3.WdSpendCat,'') as 'Worktag-3'
,isnull(Worktag4.WdRevenueCat,'') as 'Worktag-4'
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
into #tempaccountLBal
from [production_finance].[dbo].[glt_trns_dtl]
RIGHT JOIN [production_finance].[dbo].[glk_key_mstr]
	ON glt_trns_dtl.glt_gl_key = glk_key_mstr.glk_key
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsOrgKey_WdFund] Worktag1
	ON glk_key_mstr.glk_key = Worktag1.OsOrgKey
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsOrgKey_WdCostCenter] Worktag2
	ON  glk_key_mstr.glk_key = Worktag2.OsOrgKey
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsObjCd_WdSpendCat] Worktag3
	ON  glt_trns_dtl.GLT_GL_OBJ = Worktag3.OsObjCode
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsObjCd_WdRevCat] Worktag4
	ON  glt_trns_dtl.GLT_GL_OBJ = Worktag4.OsObjCode
LEFT JOIN [it.macomb_dba].[dbo].[CW_FIN_OsObjCd_WdLedger] WdLedger
	ON  glt_trns_dtl.GLT_GL_OBJ = WdLedger.OsObjCode
WHERE glt_trns_dtl.glt_date BETWEEN CASE
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'DEC' THEN convert(date,'12/31/'+cast(year(getdate())-2 as varchar),101)
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'JUN' THEN convert(date,'06/30/'+cast(year(getdate())-1 as varchar),101)
	WHEN glk_key_mstr.GLK_SEL_CODE07 = 'SEP' THEN convert(date,'09/30/'+cast(year(getdate())-1 as varchar),101)
END AND getdate()
and trim(glt_trns_dtl.GLT_BATCH_ID) <> ''
--and not trim(glt_trns_dtl.glt_batch_id) in ('ARB21087','C22210158') --Temp fix for unbalanced accounts
order by glt_trns_dtl.GLT_BATCH_ID, glt_trns_dtl.unique_id


SELECT * FROM #tempaccountLBal
WHERE AccountingJournalID not in (
select AccountingJournalID /*, sum(DebitAmount),Sum(CreditAmount) */
from  #tempaccountLBal
group by AccountingJournalID
having sum(LedgerDebitAmount) <> Sum(LedgerCreditAmount) )
order by AccountingJournalID

DROP TABLE dbo.[#tempaccountLBal]