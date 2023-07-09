$NewConfiguration = @{
    '$schema' = 'https://aka.ms/PowerShell/Crescendo/Schemas/2021-11'
    Commands  = @()
}
$OutHandler = New-OutputHandler
$OutHandler.ParameterSetName = 'Default'
$OutHandler.Handler = 'parseExtension'
$OutHandler.HandlerType = 'Function'

$Usage = New-UsageInfo -usage 'Show installed extensions for VSCode Insiders'

$Parameters = @{
	originalCommand = 'code-insiders --list-extensions --show-versions'
	command = 'Show-VSCIInstalledExtension'
	description = 'Show installed extensions for VSCode Insiders'
}
$Example = New-ExampleInfo @Parameters

$parameters = @{
    Verb         = 'Show'
    Noun         = 'VSCIInstalledExtension'
    OriginalName = 'code-insiders'
}
$Command = New-CrescendoCommand @parameters
$Command.OriginalCommandElements = @("--list-extensions","--show-versions")
$Command.Description = 'Show installed extensions for VSCode Insiders'
$Command.Platform = @('Windows','Linux','MacOS')
$Command.OutputHandlers = $OutHandler
$Command.DefaultParameterSetName = 'Default'
$Command.Usage = $Usage
$Command.Examples = $Example
$Command.ConfirmImpact = 'None'
$NewConfiguration.Commands += $Command
$NewConfiguration | ConvertTo-Json -Depth 10 | Out-File .\vscodeinsiders.crescendo.config.json

# Always import the outputhandler files with dot sourcing before you build your module.
. .\parseExtension.ps1

$Parameters = @{
    ConfigurationFile = '.\vscodeinsiders.crescendo.config.json'
    ModuleName        = 'Crescendo.VSCode'
    Force             = $true
}
Export-CrescendoModule @Parameters

Import-Module .\Crescendo.VSCode.psd1 -Force
Get-Command -Module Crescendo.VSCode
Show-VSCIInstalledExtension