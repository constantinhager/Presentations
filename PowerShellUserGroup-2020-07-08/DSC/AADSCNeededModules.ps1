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
    if (-not(Get-AzAutomationModule -AutomationAccountName "$($env:AUTOMATIONACCOUNTNAME)" -Name $module.Name -ResourceGroupName "$($env:AUTOMATIONACCOUNTRGNAME)")) {
        $splat = @{
            AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
            ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
            Name                  = $module.Name
            ContentLinkUri        = "https://www.powershellgallery.com/api/v2/package/$($module.Name)/$($module.Version)"
        }

        New-AzAutomationModule @splat
    }
}