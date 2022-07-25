$splat = @{
    ResourceGroupName     = "$($env:DSCSARGNAME)"
    ConfigurationPath     = "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)/DSCExtension/DSCExtension/CreateFile/Config.ps1"
    ConfigurationDataPath = "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)/DSCExtension/DSCExtension/CreateFile/Config.psd1"
    StorageAccountName    = "$($env:DSCSANAME)"
    ContainerName         = "$($env:DSCSAContainerName)"
    Force                 = $true
}

Publish-AzVMDscConfiguration @splat