$labName = 'PSWedDomainLab'

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:Network'         = 'ADNatSwitch'
    'Add-LabMachineDefinition:ToolsPath'       = "$labSources\Tools"
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2025 Datacenter (Desktop Experience)'
    'Add-LabMachineDefinition:Memory'          = 2GB
    'Add-LabMachineDefinition:DomainName'      = 'ch.local'
}

$splat = @{
    Name             = 'ADNatSwitch'
    HyperVProperties = @{ SwitchType = 'Internal'; AdapterName = 'vEthernet (ADNatSwitch)' }
    AddressSpace     = '192.168.80.0/24'
}
Add-LabVirtualNetworkDefinition @splat

# Root Domain Controller
$splat = @{
    VirtualSwitch = 'ADNatSwitch'
    UseDhcp       = $true
}
$netAdapter = New-LabNetworkAdapterDefinition @splat

# Optional: Post Installation Activity to prepare the Root Domain
<#$Parameters = @{
    ScriptFileName   = 'PrepareRootDomain.ps1'
    DependencyFolder = "$labSources\PostInstallationActivities\PrepareRootDomain"
}
$postInstallActivity = Get-LabPostInstallationActivity @Parameters #>
$splat = @{
    Name           = 'DomainLabDC'
    NetworkAdapter = $netAdapter
    Roles          = 'RootDC'
    #PostInstallationActivity = $postInstallActivity
}
Add-LabMachineDefinition @splat

# Member Server
$splat = @{
    VirtualSwitch = 'ADNatSwitch'
    UseDhcp       = $true
}
$netAdapter = New-LabNetworkAdapterDefinition @splat
$splat = @{
    Name           = 'DomainLabMS'
    Processors     = 2
    NetworkAdapter = $netAdapter
}
Add-LabMachineDefinition @splat

Install-Lab

Show-LabDeploymentSummary
