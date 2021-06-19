$DSCModules = New-Object -TypeName 'System.Collections.Generic.List[System.Object]'

$row1 = [PSCustomObject]@{
    Name    = 'ActiveDirectoryDSC'
    Version = '6.0.1'
}

$row2 = [PSCustomObject]@{
    Name    = 'ComputerManagementDSC'
    Version = '8.4.0'
}

$row3 = [PSCustomObject]@{
    Name    = 'StorageDSC'
    Version = '5.0.1'
}

$row4 = [PSCustomObject]@{
    Name    = 'xPSDesiredStateConfiguration'
    Version = '9.0.1'
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
        ContentLinkUri        = "https://www.powershellgallery.com/api/v2/package/$($module.Name)/$($module.Version)"
    }
    $retval = New-AzAutomationModule @splat

    while ($retval.ProvisioningState -eq "Creating") {
        Start-Sleep -Seconds 2
        Write-Output "Module $($module.Name) is not imported correctly."
        $splat = @{
            AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
            ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
            Name                  = $module.Name
        }
        $retval = Get-AzAutomationModule @splat
    }
}