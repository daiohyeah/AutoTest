<#
.SYNOPSIS
    This module file contains mathematics functions

.DESCRIPTION
    This module file contains mathematics functions

.NOTES
    For testing only
#> 

function Test-Even {
    <#
    .SYNOPSIS
        Check if the number is even.
    .DESCRIPTION
        Check if the number is even. If even, return true.
    .Parameter number
        The number needs to be tested.
    .EXAMPLE 
        Test-Even -number 2
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]
        $number
    )

    if ($number % 2 -eq 0) {
        return $true
    }
    else {
        return $false
    }
}


function Test-Odd {
    <#
    .SYNOPSIS
        Check if the number is odd.
    .DESCRIPTION
        Check if the number is odd. If odd, return true.
    .Parameter number
        The number needs to be tested.
    .EXAMPLE 
        Test-Even -number 2
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]
        $number
    )

    if ($number % 2 -eq 0) {
        return $false
    }
    else {
        return $true
    }
}