Get-Content "O:\1 Workday\Configuration Phase\1a HCM Configuation Conversion Workbooks\80_Scripts\02_PS\settings.txt" | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

$file = "PayRoll_Student Loan"
$SQLScript = $file + ".sql"
$OutFile = $file + ".csv"

$script = $h.PAYSQLPath + $SQLScript
$CSVOut = $h.PAYOutPath + $OutFile

Invoke-DbaQuery -SqlInstance $h.server -database $h.database -File $script | ConvertTo-Csv -NoTypeInformation -Delimiter $h.delimiter | % {$_.Replace('"','')} | Out-File -Encoding $h.encoding $CSVOut
