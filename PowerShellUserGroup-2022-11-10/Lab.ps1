Import-Module AutomatedLab

$labName = 'PSUGNTFS'
$domainName = 'psugntfs.net'

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

Add-LabVirtualNetworkDefinition -Name $labName
Add-LabVirtualNetworkDefinition -Name "$LabName External Switch" -HyperVProperties @{ SwitchType = 'External'; AdapterName = 'Ethernet' }

Add-LabDomainDefinition -Name $domainName -AdminUser Install -AdminPassword 'Start.12345!'

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:ToolsPath'       = "$labSources\Tools"
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2022 Datacenter (Desktop Experience)'
    'Add-LabMachineDefinition:Memory'          = 2048MB
}

Set-LabInstallationCredential -Username Install -Password 'Start.12345!'

# What is the difference between DC, ADDS and RootDC?
$Parameters = @{
    ScriptFileName   = 'New-ADLabAccounts 2.0.ps1'
    DependencyFolder = "$labSources\PostInstallationActivities\PrepareFirstChildDomain"
}
$postInstallActivity = Get-LabPostInstallationActivity @Parameters

$Parameters = @{
    Name                     = 'NTFSDC'
    Roles                    = 'RootDC'
    PostInstallationActivity = $postInstallActivity
    DomainName               = $domainName
    Network                  = $labName
}
Add-LabMachineDefinition @Parameters

$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch $LabName
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch "$LabName External Switch" -UseDhcp

$Parameters = @{
    Name           = 'NTFSRouter'
    Memory         = 1GB
    Roles          = 'Routing'
    NetworkAdapter = $netAdapter
    DomainName     = $domainName
}
Add-LabMachineDefinition @Parameters

$Parameters = @{
    Name           = 'NTFSFS1'
    Roles          = 'FileServer'
    DomainName     = $domainName
    IsDomainJoined = $true
    Network        = $labName
}
Add-LabMachineDefinition @Parameters

$Parameters = @{
    Name           = 'NTFSFS2'
    Roles          = 'FileServer'
    DomainName     = $domainName
    IsDomainJoined = $true
    Network        = $labName
}
Add-LabMachineDefinition @Parameters

Install-Lab

$Parameters = @{
    ComputerName = 'NTFSFS1', 'NTFSFS2'
    FeatureName  = 'RSAT-AD-PowerShell'
}
Install-LabWindowsFeature @Parameters

$Parameters = @{
    ActivityName = 'Install NTFSSecurity on Fileservers'
    ComputerName = 'NTFSFS1', 'NTFSFS2'
    FilePath     = 'InstallNeededPrerequisites.ps1'
}
Invoke-LabCommand @Parameters

$Parameters = @{
    ActivityName = 'Add FS Admin Groups'
    ComputerName = 'NTFSDC'
    FilePath     = 'AddFSAdGroups.ps1'
}
Invoke-LabCommand @Parameters

$Parameters = @{
    ActivityName = 'Add Sample File Server Struture'
    ComputerName = 'NTFSFS1'
    FilePath     = 'CreateSampleFSStructureFS1.ps1'
}
Invoke-LabCommand @Parameters

$Parameters = @{
    ActivityName = 'Generate File Server Report'
    ComputerName = 'NTFSFS1'
    FilePath     = 'FileServerReport.ps1'
}
Invoke-LabCommand @Parameters

$Parameters = @{
    ActivityName = 'Add Same Filestructure to FS2'
    ComputerName = 'NTFSFS2'
    FilePath     = 'CreateSampleFSStructureFS2.ps1'
}
Invoke-LabCommand @Parameters

$Parameters = @{
    ActivityName = 'Apply FS Report to FS2'
    ComputerName = 'NTFSFS2'
    FilePath     = 'ApplyFSReport.ps1'
}
Invoke-LabCommand @Parameters