<# 
.Synopsis 
   Write-Log writes a message to a specified log file with the current time stamp.
#>

Function Write-Log {
    <#
    .SYNOPSIS
        Write a message to a specified log file
    .Parameter Level
        The lelvel of logs, "INFO","WARN","ERROR","FATAL","DEBUG"
    .Parameter Message
        The content of logs
    .EXAMPLE 
        Write-Log -Level INFO "Test"
    #>
    [CmdletBinding()]
    Param(
    [Parameter(Mandatory=$True)]
    [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
    [String]
    $Level,

    [Parameter(Mandatory=$True)]
    [string]
    $Message
    )

    $Stamp = (Get-Date).toString("yyyy-MM-dd")
    $logname = $Stamp+".log"
    $logfile = Join-Path $LogFolder $logname
    if (!(Test-Path $logfile)) {
        New-Item $logfile -Force
    }

    $Stamp = (Get-Date).toString("yyyy-MM-dd HH:mm:ss")
    $Line = "$Stamp $Level $Message"
        Add-Content $logfile -Value $Line
        Write-Host $Line
    }
