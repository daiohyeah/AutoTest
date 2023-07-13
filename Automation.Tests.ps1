<#
    .SYNOPSIS
        Contains the pester training test cases.
    .NOTES
        Version of Pester needs 4.x, if version higher than 5.x, this scrpit may not work correctly. 
#>

Describe "pester training testing" {
    # Version of Pester needs 4.x not 5.x, otherwise BeforeAll and AfterAll will not work.
    BeforeAll {
        ConnectToXenserver
    }
    
    AfterAll {
        DisconnectToXenserver
    }

    Context "Check if the number is even" {
        It "number 2 should be even" {
            CheckifEvenNumber 2 | Should -Be $true
        }
        It "number 1 should not be even" {
            CheckifEvenNumber 1 | Should -Be $false
        }
    }

    Context "Xenserver VM power state Testing" {
        It "Check power state of VM1 is power off" {
            Get-XenVMPowerState $xsvm1 | Should -Be 'Halted'
        }
        It "Check power state of VM2 is power on" {
            Get-XenVMPowerState $xsvm2 | Should -Be 'Running'
        }
    }
    
    Context "Xenserver VM power management Testing" {
        It "Start vm1" {
            { Start-XenVM $xsvm1} | Should -Not -Throw
        }
        It "Stop vm2" {
            { Stop-XenVM $xsvm2} | Should -Not -Throw
        }
    }
    
}
