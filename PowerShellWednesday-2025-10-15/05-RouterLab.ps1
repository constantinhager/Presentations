$labName = 'PSWedRouterLab'

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:Network'         = 'NATSwitch'
    'Add-LabMachineDefinition:ToolsPath'       = "$labSources\Tools"
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows Server 2025 Datacenter (Desktop Experience)'
    'Add-LabMachineDefinition:Memory'          = 2GB
    'Add-LabMachineDefinition:DomainName'      = 'ch.local'
}

$splat = @{
    Name             = 'NATSwitch'
    HyperVProperties = @{ SwitchType = 'Internal'; AdapterName = 'vEthernet (NATSwitch)' }
    AddressSpace     = '192.168.100.0/24'
}
Add-LabVirtualNetworkDefinition @splat
Add-LabVirtualNetworkDefinition -Name $LabName -AddressSpace '192.168.90.0/24'

$netAdapter = @()
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch $LabName
$netAdapter += New-LabNetworkAdapterDefinition -VirtualSwitch 'NATSwitch' -UseDhcp
$Parameters = @{
    Name            = 'RouterLabRouter'
    Roles           = 'Routing'
    NetworkAdapter  = $netAdapter
    OperatingSystem = 'Windows Server 2022 Datacenter (Desktop Experience)'
}
Add-LabMachineDefinition @Parameters

# Root Domain Controller
$Parameters = @{
    Name                     = 'RoutingLabDC'
    Network                  = $LabName
    Roles                    = 'RootDC'
}
Add-LabMachineDefinition @Parameters

Install-Lab

Show-LabDeploymentSummary
