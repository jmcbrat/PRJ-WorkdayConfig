--PayRoll_Deduction Recipients
insert into [IT.Macomb_DBA].[dbo].smoketest
SELECT 'PayRoll' as Spreadsheet
,'Deduction Recipients' as TabName
,'PayRoll_Deduction Recipients' as QueryName
,ISNULL(ROOTCnt,0) as ROOTCNT
,ISNULL(RoadCNT,0) as ROADCNT
,ISNULL(PENSCnt,0) as PENSCNT
,ISNULL(ZINSCNT,0) as ZINSCNT
,ISNULL(ROOTRet,0) as ROOTRet
,ISNULL(ROADRet,0) as ROADRet
,ISNULL(PENSRet,0) as PENSRet
,ISNULL(TotalRecords,0) as TotalRecords
FROM (

SELECT 'TotalRecords' AS ColName, 2 as CNT
/* from taken from the main query below*/

/* end of grab */

) AS Tb2Pivot
  PIVOT
  (
  SUM(CNT) FOR Tb2Pivot.ColName in ([ROOTCnt],[ROADCnt],[PENSCnt],[ZINSCnt],[ROOTRet],[ROADRet],[PENSRet],[TotalRecords])
  ) as PivotTable;






SELECT
'County of Macomb, Michigan' as 'DeductionRecipientName'
,'Steve Smigiel' as 'SourceSystem'
,'' as 'AlternateDeductionRecipientName'
,'DR-001' as 'DeductionRecipientID'
,'Check' as 'PaymentType'
,'County of Macomb, Michigan' as 'BusinessEntityName'
,'' as 'BusinessEntityTaxID'
,'DR-001' as 'ExternalEntityID'
,'' as 'EmailAddress'
,'' as 'CountryISOCodePhone'
,'' as 'InternationalPhoneCode'
,'' as 'PhoneNumber'
,'' as 'PhoneExtension'
,'' as 'PhoneDeviceType'
,'Business' as 'TypeReference'
,'' as 'UseForReferencePhone'
,'USA' as 'CountryISOCodeAddress'
,'' as 'Effectiveasof'
,'120 N Main, 2nd Floor' as 'AddressLine#1'
,'' as 'AddressLine#2'
,'Mount Clemens' as 'City'
,'' as 'CitySubdivision'
,'' as 'CitySubdivision2'
,'USA-MI' as 'Region'
,'' as 'RegionSubdivision'
,'' as 'RegionSubdivision2'
,'48043' as 'PostalCode'
,'' as 'UseForReferenceAddress'
,'' as 'CountryISOCodeBank'
,'USD' as 'CurrencyCode'
,'' as 'BankAccountNickname'
,'' as 'BankName'
,'' as 'BankAccountTypeCode'
,'' as 'RoutingNumber(BankID)'
,'' as 'BranchID'
,'' as 'BranchName'
,'' as 'BankAccountNumber'
,'' as 'BankAccountName'
,'' as 'RollNumber'
,'' as 'CheckDigit'
,'' as 'IBAN'
,'' as 'SWIFTBankIdentificationCode'
UNION ALL
SELECT
'MIDSU' as 'DeductionRecipientName'
,'Steve Smigiel' as 'SourceSystem'
,'' as 'AlternateDeductionRecipientName'
,'DR-002' as 'DeductionRecipientID'
,'Check' as 'PaymentType'
,'MIDSU' as 'BusinessEntityName'
,'' as 'BusinessEntityTaxID'
,'DR-002' as 'ExternalEntityID'
,'' as 'EmailAddress'
,'' as 'CountryISOCodePhone'
,'' as 'InternationalPhoneCode'
,'' as 'PhoneNumber'
,'' as 'PhoneExtension'
,'' as 'PhoneDeviceType'
,'Business' as 'TypeReference'
,'' as 'UseForReferencePhone'
,'USA' as 'CountryISOCodeAddress'
,'' as 'Effectiveasof'
,'PO Box 30350' as 'AddressLine#1'
,'' as 'AddressLine#2'
,'Lansing' as 'City'
,'' as 'CitySubdivision'
,'' as 'CitySubdivision2'
,'USA-MI' as 'Region'
,'' as 'RegionSubdivision'
,'' as 'RegionSubdivision2'
,'48909' as 'PostalCode'
,'' as 'UseForReferenceAddress'
,'' as 'CountryISOCodeBank'
,'USD' as 'CurrencyCode'
,'' as 'BankAccountNickname'
,'' as 'BankName'
,'' as 'BankAccountTypeCode'
,'' as 'RoutingNumber(BankID)'
,'' as 'BranchID'
,'' as 'BranchName'
,'' as 'BankAccountNumber'
,'' as 'BankAccountName'
,'' as 'RollNumber'
,'' as 'CheckDigit'
,'' as 'IBAN'
,'' as 'SWIFTBankIdentificationCode'
