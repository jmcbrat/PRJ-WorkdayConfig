$INI = Get-Content "O:\1 Workday\Configuration Phase\1a HCM Configuration Conversion Workbooks\80_Scripts\02_PS\settings.txt"

$IniHash = @{}

$GroupVal
$ProcessVal
$Processes = @()
[Int]$PStart = 0

ForEach($Line in $INI)
{
  IF ( $Line.StartsWith("#") -ne $True) {
  IF ($Line -eq "" ){
   $GrgoupVal = ""
   $ProcessVal = ""
   $PStart = 0
  }
  IF ( $Line.StartsWith("<") -eq $True) {
    $ProcessVal = $Line.Replace("<","").Replace(">","")
    $GroupVal = ""
    $PStart = 1
  }
  If ( $Line.StartsWith("[") -eq $True) {
    $GroupVal = $Line.Replace("[","").Replace("]","")
    $ProcessVal = ""
    $PStart = 1
  }
  IF ($PStart -eq 2 -and ($GroupVal -ne "" -or $ProcessVal -ne "" -or $Line -ne "")) {
    IF ($GroupVal -ne "") {
      $SplitArray = $Line.Split("=")
      $IniHash += @{($GroupVal+"."+$SplitArray[0]) = $SplitArray[1]}
    }
    IF ($ProcessVal -ne ""){
      $Processes += $Line
    }
  }
  IF ($PStart = 1){$PStart = 2}
  }  
}


#write-host "Loopping"
ForEach($Process in $Processes)
    {
    $oPath = ''
    $spath = ''
    $job = ''

    $SplitArray = $Process.Split(",")
    $oPath = $IniHash["Locations.Root"] + $SplitArray[2]+$SplitArray[0]+'.csv'
    $sPath = $IniHash["Locations.Root"] + $SplitArray[1]+$SplitArray[0]+'.sql'
    $Job = $SplitArray[0]

    #Write-Host "Job: $Job Runs sql: $sPath Writes to: $oPath"
    $Delimiter = $IniHash['OutPutFILE.delimiter']
    $Encoding = $IniHash['OutPutFILE.Encoding']
    $Server = $IniHash['OutPutFILE.server']
    $db = $IniHash['OutPutFILE.database']
    
    Invoke-DbaQuery -SqlInstance $Server -database $db -File $sPath | ConvertTo-Csv -NoTypeInformation -Delimiter $Delimiter | % {$_.Replace('"','')} | Out-File -Encoding $Encoding $oPath
    #Invoke-DbaQuery -SqlInstance $h.server -database $h.database -File $script | ConvertTo-Csv -NoTypeInformation -Delimiter $h.delimiter | % {$_.Replace('"','')} | Out-File -Encoding $h.encoding $CSVOut

    Write-Host $Job
    }
