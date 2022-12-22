$ImportFile_SO = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Supervisory_Org.csv'
$ImportFile_EP = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\EMP_Position_MGT.csv'
$importFile_Dept = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\DEPT_CODES_LIST.csv'
$importFile_Dept2 = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\DEPT_CODES_LIST2.csv'
$importFileinx = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\JOBCODEMAP.csv'
$importFileAD = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\OneSolution_AD_account.csv'

$importFileRole = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Security_Assign_Role_based.csv'
$importFileUser = 'O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\40_custom tables\Security_Assign_User_based.csv'

$sInstance = 'WISC11\DV'
$sDB = 'IT.Macomb_DBA'


#Import-DbaCsv -Path $ImportFile_SO -SqlInstance $sInstance -Database $sDB -AutoCreateTable

Import-DbaCsv -Path $ImportFile_EP -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFile_Dept -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFile_Dept2 -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFileinx -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFileAD -SqlInstance $sInstance -Database $sDB -AutoCreateTable

#Import-DbaCsv -Path $importFileRole  -SqlInstance $sInstance -Database $sDB -AutoCreateTable
#Import-DbaCsv -Path $importFileUser -SqlInstance $sInstance -Database $sDB -AutoCreateTable

