$DSCModules = New-Object -TypeName 'System.Collections.Generic.List[System.Object]'

$row1 = [PSCustomObject]@{
    Name    = 'ActiveDirectoryDSC'
    Version = '6.0.1'
}

$row2 = [PSCustomObject]@{
    Name    = 'ComputerManagementDSC'
    Version = '8.5.0'
}

$row3 = [PSCustomObject]@{
    Name    = 'StorageDSC'
    Version = '5.0.1'
}

$row4 = [PSCustomObject]@{
    Name    = 'xPSDesiredStateConfiguration'
    Version = '9.1.0'
}

$DSCModules.Add($row1)
$DSCModules.Add($row2)
$DSCModules.Add($row3)
$DSCModules.Add($row4)

foreach ($module in $DSCModules) {
    $splat = @{
        AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
        ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
        Name                  = $module.Name
    }
    $retval = Get-AzAutomationModule @splat

    if ($null -ne $retval) {
        Write-Output "Module $($module.Name) already exists. Check if version is the one we need."
        if ($module.Version -eq $retval.Version) {
            Write-Output "Module $($module.Name) is already up to date."
        } else {
            Write-Output "Module $($module.Name) is not up to date. Updating..."

            $splat = @{
                AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
                ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
                Name                  = $module.Name
                ContentLinkUri        = "https://www.powershellgallery.com/api/v2/package/$($module.Name)/$($module.Version)"
            }
            $retval = New-AzAutomationModule @splat

            while ($retval.ProvisioningState -eq 'Creating') {
                Start-Sleep -Seconds 2
                Write-Output "Module $($module.Name) is not completely imported."
                $splat = @{
                    AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
                    ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
                    Name                  = $module.Name
                }
                $retval = Get-AzAutomationModule @splat
            }
        }
    } else {
        Write-Output "Importing module $($module.Name) into AutomationAccount $($env:AUTOMATIONACCOUNTNAME)"
        $splat = @{
            AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
            ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
            Name                  = $module.Name
            ContentLinkUri        = "https://www.powershellgallery.com/api/v2/package/$($module.Name)/$($module.Version)"
        }
        $retval = New-AzAutomationModule @splat

        while ($retval.ProvisioningState -eq 'Creating') {
            Start-Sleep -Seconds 2
            Write-Output "Module $($module.Name) is not completely imported."
            $splat = @{
                AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
                ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
                Name                  = $module.Name
            }
            $retval = Get-AzAutomationModule @splat
        }
    }
}