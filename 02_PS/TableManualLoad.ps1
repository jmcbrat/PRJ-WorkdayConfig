$ImportFile_SO = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\Supervisory_Org.csv'
$ImportFile_EP = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\EMP_Position_MGT.csv'
$importFile_Dept = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\DEPT_CODES_LIST.csv'
$importFile_Dept2 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\DEPT_CODES_LIST2.csv'
$importFileinx = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\JOBCODEMAP.csv'
$importFileAD = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\OneSolution_AD_account.csv'

$importFileRole = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\Security_Assign_Role_based.csv'
$importFileUser = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\Security_Assign_User_based.csv'

$importcrosswalk1 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\01_raw SQL\04_Tables\CrosswalksCrosswalks.csv'
$importcrosswalk2 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\01_raw SQL\04_Tables\CrosswalksObjecttoLedgerCd_SpendCat.csv'
$importcrosswalk3 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\01_raw SQL\04_Tables\CrosswalksOS Orgkey to WD CC.csv'

$importcrosswalk10 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Extract_Spend_Categories.csv'
$importcrosswalk11 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Extract_Spend_Categories_Location Reference CW.csv'
$importcrosswalk12 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Extract_Spend_Categories_Location.csv'
$importcrosswalk13 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Asset Type Class Crosswalk.csv'
$importcrosswalk14 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\ONESOLUTION2WORKDAY_ASSET_class.csv'
$importcrosswalk15 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\ONESOLUTION2WORKDAY_ASSET_TYPE.csv'
$importcrosswalk16 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend Asset Class CW.csv'
$importcrosswalk17 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend Asset Type CW.csv'
$importcrosswalk18 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend Spend Category CW.csv'
$importcrosswalk19 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend Spend Category CW.csv'
$importcrosswalk20 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend Orgkey to CC CW.csv'
$importcrosswalk21 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend OS FA Dept Code to CC CW.csv'
$importcrosswalk22 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Macomb_Accounting_Spend OS FA Dept to WD Company CW.csv'
$importcrosswalk23 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\EFTVendorsBankName.CSV'

$importcrosswalk24 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\01_raw SQL\04_Tables\ASSET_CLASS_CROSSWALK.CSV'
$importcrosswalk25 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\01_raw SQL\04_Tables\ASSET_TYPE_CROSSWALK.CSV'
$importcrosswalk26 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Location_Reference_Crosswalk.CSV'
$importcrosswalk27 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\Fund_Mapping_Key.CSV'
$importcrosswalk28 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\PT_Hours_Worked_for_Absence.csv'
$importcrosswalk29 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\Department of Roads.csv'

$importcrosswalk30 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\CW_FIN_OsObjCd_WdLedger.csv'
$importcrosswalk31 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\CW_FIN_OsObjCd_WdRevCat.csv'
$importcrosswalk32 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\CW_FIN_OsObjCd_WdSpendCat.csv'
$importcrosswalk33 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\CW_FIN_OsOrgKey_WdCostCenter.csv'
$importcrosswalk34 = 'O:\1 Workday\E2E Extract\4 - Custom Tables - Crosswalks\CW_FIN_OsOrgKey_WdFund.csv'

$Marco = 'C:\Users\jmcbra\Downloads\TblSecurity.csv'
$marcophone = 'C:\Users\jmcbra\Downloads\ENTITY_ORGANIZATION.csv'

$sInstance = 'WISC11\DV'
$sDB = 'IT.Macomb_DBA'


Import-DbaCsv -Path $ImportFile_SO -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $ImportFile_EP -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFile_Dept -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFile_Dept2 -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFileinx -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFileAD -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFileRole  -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFileUser -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importcrosswalk1 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk2 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk3 -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importcrosswalk10 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk11 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk12 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk13 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk14 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk15 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk16 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk17 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk18 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk19 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk20 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk21 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk22 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk23 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk24 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk25 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk26 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk27 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk28 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk29 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk30 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk31 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk32 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk33 -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importcrosswalk34 -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#import-dbacsv -path $marcophone -sqlinstance wisc10\dv -database SH.BondDeposits -autocreatetable 