<#
.SYNOPSIS
    Contains the sequences of commands used in *.Tests.ps1 or InvokePester.ps1
#>
function LoadGlobalVariables {
    <#
    .SYNOPSIS
        Read parameters from config file and set global variable.
    .Parameter Config
        The parsed content of config json file.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [PSObject]
        $Config
    )
    
    Write-Host "Loading global variables"
    
    # Log Folder
    Set-Variable -Name "LogFolder"          -Value $Config.SavePath.logFolderPath        -Scope Global

    # Test Result Folder
    Set-Variable -Name "ResultsPath"        -Value $Config.SavePath.ResultsPath          -Scope Global

    # Read some parameters from config for XenServer
    Set-Variable -Name "xsurl"              -Value $Config.XenServer.url                 -Scope Global
    Set-Variable -Name "xsusername"         -Value $Config.XenServer.username            -Scope Global
    Set-Variable -Name "xspassword"         -Value $Config.XenServer.password            -Scope Global
    Set-Variable -Name "xsvm1"              -Value $Config.XenServer.vm1                 -Scope Global
    Set-Variable -Name "xsvm2"              -Value $Config.XenServer.vm2                 -Scope Global
}

function CheckifEvenNumber {
    <#
    .SYNOPSIS
        Check if the number is even.
    .Parameter number
        The number needs to be tested.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]
        $number
    )
    try {
        Test-Even -number $number
        Write-log -Level INFO "The number $number is tested successfully."
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
    }
}

function ConnectToXenserver {
    <#
    .SYNOPSIS
        Connect to Xenserver with correct credentials in config file.
    #>
    try {
        Connect-XenServer -Url $xsurl -UserName $xsusername -Password $xspassword
        Write-log -Level INFO "Connect to Xenserver $xsurl successfully"
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
    }
}


function Get-XenVMPowerState {
    <#
    .SYNOPSIS
        Get power state of VM.
    .Parameter name
        The name of Xenserver VM.
    .OUTPUTS
        The state of VM. For Example: Halted, Running
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $name
    )
    try {
        $s= Get-XenVM -Name $name
        $power_state = $s.power_state
        Write-log -Level INFO "The power state of $name is $power_state"
        return $power_state
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
    }

}

function Start-XenVM {
    <#
    .SYNOPSIS
        Power on a XenServer VM.
    .DESCRIPTION
        Start Xenserver VM if VM is poweroff 
    .Parameter name
        The name of Xenserver VM.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $name
    )

    $power_state = Get-XenVMPowerState $name

    try {
        if ($power_state -eq 'Halted') {
            Invoke-XenVM -Name $name -XenAction Start
            Write-log -Level INFO "Start Xenserver VM $name successuflly"
        }
        else {
            Write-log -Level ERROR "The power state of $name is not halted, please check."
            throw "The power state of $name is not halted, please check."
        }
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
        }
}

function Stop-XenVM {
    <#
    .SYNOPSIS
        Power off a XenServer VM.
    .DESCRIPTION
        Shut down Xenserver VM if VM is poweron
    .Parameter name
        The name of Xenserver VM.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $name
    )

    $power_state = Get-XenVMPowerState $name

    try {
        if ($power_state -eq 'Running') {
            Invoke-XenVM -Name $name -XenAction Shutdown
            Write-log -Level INFO "Stop Xenserver VM $name successuflly"
        }
        else {
            Write-log -Level ERROR "The power state of $name is not running, please check."
            throw "The power state of $name is not running, please check."
        }
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
        }
}


function DisconnectToXenserver {
    <#
    .SYNOPSIS
        Disconnect to Xenserver.
    #>
    try {
        Disconnect-XenServer
        Write-log -Level INFO "Disconnect to Xenserver successfully"
    }
    catch {
        Write-log -Level ERROR $_.Exception.message
        throw $_.Exception
    }
}