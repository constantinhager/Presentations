foreach ($mof in (Get-ChildItem -Path "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)/mof" -Filter '*.mof')) {
    $splat = @{
        AutomationAccountName = "$($env:AUTOMATIONACCOUNTNAME)"
        ResourceGroupName     = "$($env:AUTOMATIONACCOUNTRGNAME)"
        ConfigurationName     = [System.IO.Path]::GetFileNameWithoutExtension($mof.FullName)
        Path                  = "$($mof.FullName)"
        Force                 = $true
    }

    Import-AzAutomationDscNodeConfiguration @splat
}