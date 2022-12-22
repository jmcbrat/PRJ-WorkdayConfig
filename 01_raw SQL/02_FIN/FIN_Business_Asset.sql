/*
Macomb_Accounting_Template_Business Asset_V1Sean.xlsx
TabName: Business_Assets
*/
SELECT
 trim(fa_idnt.FAID) as 'BusinessAssetID'
,'"Dave Stiteler, Alex Ryder"' as 'SourceSystem'
,'C0001' as 'CompanyOrganization'
,trim(fa_idnt.f_desc) as 'BusinessAssetName'
,'' as 'BusinessAssetDescription'
,'SC0275' as 'SpendCategory'
,CASE WHEN fa_idnt.tc = 'CAPITAL' THEN 'Capitalized' WHEN fa_idnt.tc = 'NON_CAP' THEN 'Expense' ELSE 'Non-Depreciable_Capital_Asset' END as 'AccountingTreatment'
,'Purchased' as 'AcquisitionMethodReference'
,IIF(fa_idnt.other_info is null, '',trim(fa_idnt.other_info)) as 'Memo'
,fa_idnt.purchamt as 'AcquisitionCost'
,fa_idnt.salamt as 'ResidualValue'
,'' as 'FairMarketValue'
,fa_idnt.QTY as 'Quantity'
,replace(convert(varchar, fa_idnt.inservdt, 106),' ','-') as 'DateAcquired'
,replace(convert(varchar, fa_idnt.inservdt, 106),' ','-') as 'DatePlacedinService'
--,trim(fa_site.bldg) as 'LocationReference'
,trim(asset_location_cw.Workday_Reference_ID) as 'LocationReference'
,'' as 'RelatedAsset'
--,trim(fa_idnt.sc) as 'AssetClass'
,trim(asset_class_cw.New_Workday_Value) as 'AssetClass'
--,trim(fa_idnt.pc) as 'AssetType'
,trim(asset_type_cw.New_Workday_Value) as 'AssetType'
,'' as 'CoordinatingCostCenter'
,trim(fa_idnt.faid) as 'AssetIdentifier'
,IIF(fa_idnt.serialno is null,'',trim(fa_idnt.serialno)) as 'SerialNumber'
,IIF(fa_idnt.mfctid is null,'',trim(fa_idnt.mfctid)) as 'Manufacturer'
,fa_appo.PO as 'PONumber'
,'' as 'ReceiptNumber'
,fa_appo.INVOICE as 'SupplierInvoiceNumber'
,'' as 'ProjectNumber'
,'' as 'ExternalContractNumber'
,'' as 'ContractStartDate'
,'' as 'ContractEndDate'
,'' as 'LastIssueDate'
,'' as 'WorkerID'
,'' as 'WorkerType'
,'STRAIGHT_LINE' as 'DepreciationProfileOverrideReference'
,'STRAIGHT_LINE' as 'DepreciationMethodOverrideReference'
,fa_depr.life as 'UsefulLifeinPeriodsOverride'
,'' as 'DepreciationStartDate'
,fa_depr.liferem as 'RemainingDepreciationPeriods'
,fa_depr.accamt as 'AccumulatedDepreciation'
,fa_depr.ytdamt as 'YearToDateDepreciation'
,'' as 'DepreciationPercentOverride'
,'' as 'DepreciationThresholdOverride'
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
FROM 
[production_finance].[dbo].[fa_idnt] 
right join [production_finance].[dbo].[fa_site]
	on fa_idnt.FAID = fa_site.FAID
left join [production_finance].[dbo].[fa_appo]
	on fa_idnt.FAID = fa_appo.FAID
left join [production_finance].[dbo].[fa_depr]
	on fa_idnt.FAID = fa_depr.FAID
left join [it.macomb_dba].[dbo].[onesolution2workday_asset_class] asset_class_cw
	on trim(fa_idnt.sc) = trim(asset_class_cw.OneSolution_Code)
left join [it.macomb_dba].[dbo].[onesolution2workday_asset_type] asset_type_cw
	on trim(fa_idnt.pc) = trim(asset_type_cw.[OneSolution Code])
left join [it.macomb_dba].[dbo].[Location_Reference_Crosswalk] asset_location_cw
	on trim(fa_site.bldg) = trim(asset_location_cw.OneSolution_Building_Code)

WHERE trim(fa_idnt.STAT) = 'AC'
-- CNP792: filter out bad data. Remove the below filter when corrected
AND trim(fa_idnt.FAID) <> 'MC170048'

order by 1
