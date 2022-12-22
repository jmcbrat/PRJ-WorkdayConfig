Set-AWSCredential `
                 -AccessKey ???AKIAVADLXPFD2IUZPQNZ `
                 -SecretKey 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 `
                 -StoreAs MacombCentralSquare

Get-AWSCredential -ListProfileDetail

cd b:

cd CopyOnly\centralSquare

#Get-S3Object -BucketName "my-bucket" -KeyPrefix "path/to/directory" | Read-S3Object -Folder .
Get-AWSCredential -ProfileName default

#set-EC2Image -Region us-east-2
Set-DefaultAWSRegion -Region us-east-2
Get-AWSRegion

Get-S3Object -bucketname 's3:' #://cst-dc-customer-transfer-financeenterprise/MACO/'
#FAILED
Copy-S3Object -BucketName s3 -RemoteFolder //cst-dc-customer-transfer-financeenterprise/MACO/  -LocalFolder b:\CopyOnly\centralSquare
#FAILED

Install-Module -name AWS.Tools.Common

Install-Module -Name AWS.Tools.Installer
#installed

Install-Module -Name AWS.Tools.Installer -Force

Install-Module -name AWSPowerShell.NetCore
#installed

Install-Module -Name AWSPowerShell
#installed

Install-AWSToolsModule AWS.Tools.EC2,AWS.Tools.S3 -CleanUp

Install-AWSToolsModule AWS.Tools.IdentityManagement -Scope AllUsers

Set-ExecutionPolicy RemoteSigned 

Get-AWSPowerShellVersion

Get-AWSPowerShellVersion -ListServiceVersionInfo

Update-AWSToolsModule -CleanUp

Set-AWSCredential -ProfileName MacombCentralSquare

Get-S3Bucket -ProfileName MacombCentralSquare

Get-Module -ListAvailable

#block
$bucket = 's3://cst-dc-customer-transfer-financeenterprise/MACO/ .'
$localpath = 'b:\CopyOnly\centralSquare'

$objects = Get-S3Object -BucketName $bucket -KeyPrefix //cst-dc-customer-transfer-financeenterprise/MACO/
#end block
#failed

aws configure --region us-east-2
#failed

aws s3 sync b:\CopyOnly\centralSquare s3://cst-dc-customer-transfer-financeenterprise/MACO/
#failed

aws s3 sync s3://cst-dc-customer-transfer-financeenterprise/MACO/ .
#failed