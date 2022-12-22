



SELECT 
trim(fa_idnt.FAID) as 'R-BusinessAssetID'
,'ONESolution' as 'O-SourceSystem'
,'County of Macomb' as 'R-CompanyOrganization'
,trim(fa_idnt.f_desc) as 'O-BusinessAssetName'
,'' as 'O-BusinessAssetDescription'
,'Professional_Services' as 'R-SpendCategory'
,CASE
  WHEN fa_idnt.tc = 'CAPITAL' THEN 'Capitialzed'
  WHEN fa_idnt.tc = 'NON_CAP' THEN 'Expense' 
  ELSE 'Non-Depreciable_Capital_Asset'
  END as 'R-AccountingTreatment'
,'Purchased' as 'R-AcquisitionMethodReference'
,IIF(fa_idnt.other_info is null, '',trim(fa_idnt.other_info)) as 'O-Memo'
,fa_idnt.purchamt as 'O-AcquisitionCost'
,fa_idnt.salamt as 'O-ResidualValue'
,'' as 'O-FairMarketValue'
,'' as 'O-Quantity'
,replace(convert(varchar, fa_idnt.inservdt, 106),' ','-') as 'R-DateAcquired'
,replace(convert(varchar, fa_idnt.inservdt, 106),' ','-')  as 'O-DatePlacedinService'
,trim(fa_site.bldg) as 'O-LocationReference'
,'' as 'O-RelatedAsset'
,trim(fa_idnt.pc) as 'O-AssetClass'
,trim(fa_idnt.sc) as 'O-AssetType'
,'CC_1000' as 'R-CoordinatingCostCenter'
,trim(fa_idnt.faid) as 'O-AssetIdentifier'
,IIF(fa_idnt.serialno is null,'',trim(fa_idnt.serialno)) as 'O-SerialNumber'
,IIF(fa_idnt.mfctid is null,'',trim(fa_idnt.mfctid)) as 'O-Manufacturer'
,'' as 'O-PONumber'
,'' as 'O-ReceiptNumber'
,'' as 'O-SupplierInvoiceNumber'
,'' as 'O-ProjectNumber'
,'' as 'O-ExternalContractNumber'
,'' as 'O-ContractStartDate'
,'' as 'O-ContractEndDate'
,'' as 'O-LastIssueDate'
,'' as 'O-WorkerID'
,'' as 'O-WorkerType'
,trim(fa_depr.type) as 'R-DepreciationProfileOverrideReference'
,trim(fa_depr.type) as 'O-DepreciationMethodOverrideReference'
,fa_depr.life as 'R-UsefulLifeinPeriodsOverride'
,'' as 'O-DepreciationStartDate'
,fa_depr.liferem as 'O-RemainingDepreciationPeriods'
,fa_depr.accamt as 'O-AccumulatedDepreciation'
,fa_depr.ytdamt as 'O-YearToDateDepreciation'
,'' as 'O-DepreciationPercentOverride'
,'' as 'O-DepreciationThresholdOverride'
,'' as 'O-Worktag-1'
,'' as 'O-Worktag-2'
,'' as 'O-Worktag-3'
,'' as 'O-Worktag-4'
,'' as 'O-Worktag-5'
,'' as 'O-Worktag-6'
,'' as 'O-Worktag-7'
,'' as 'O-Worktag-8'
,'' as 'O-Worktag-9'
,'' as 'O-Worktag-10'
,'' as 'O-Worktag-11'
,'' as 'O-Worktag-12'
,'' as 'O-Worktag-13'
,'' as 'O-Worktag-14'
,'' as 'O-Worktag-15'
FROM 
  [production_finance].[dbo].[fa_idnt] 
  right join [production_finance].[dbo].[fa_site]
  on fa_idnt.FAID = fa_site.FAID
  left join [production_finance].[dbo].[fa_depr]
  on fa_idnt.FAID = fa_depr.FAID

