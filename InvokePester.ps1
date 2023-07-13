<#
    .SYNOPSIS
        Prepares for the automation and calls Invoke-Pester at the end.
    .PARAMETER ConfigFile
        The config file used in testing. Should be a json file under Config.
    .NOTES
        Version of Pester needs 4.x, if version higher than 5.x, this scrpit may not work correctly. 
#>
param(
    [Parameter(Mandatory = $false)]
    [string] 
    $ConfigFile = ".\Config\test.json"
)

Import-Module XenServerPSModule
Import-Module .\Modules\shuModule.psm1
Import-Module .\Utils\LogModule.psm1
Import-Module .\AutomationModule.psm1


#Parsing config json file
$Config_json = Get-Content -Raw -Path $ConfigFile | ConvertFrom-Json

LoadGlobalVariables -Config $Config_json

if (!(Test-Path $ResultsPath)) {
    New-Item $ResultsPath -Force -ItemType Directory
}

$Stamp = (Get-Date).toString("yyyyMMdd_HHmmss")
# Version of Pester needs 4.x not 5.x
Invoke-Pester  -Script '.\Automation.Tests.ps1' -OutputFormat NUnitXml -OutputFile $ResultsPath\$Stamp.xml
Write-Host "Results are saved in $ResultsPath\$Stamp.xml"
