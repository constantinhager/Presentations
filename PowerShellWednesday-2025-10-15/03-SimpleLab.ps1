$labName = 'PSWedSimpleLab'

New-LabDefinition -Name $labName -DefaultVirtualizationEngine HyperV

$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:Network'         = 'NATSwitch'
    'Add-LabMachineDefinition:ToolsPath'       = "$labSources\Tools"
    'Add-LabMachineDefinition:OperatingSystem' = 'Windows 11 Pro'
    'Add-LabMachineDefinition:Memory'          = 2GB
}

$splat = @{
    Name             = 'NATSwitch'
    HyperVProperties = @{ SwitchType = 'Internal'; AdapterName = 'vEthernet (NATSwitch)' }
    AddressSpace     = '192.168.100.0/24'
}
Add-LabVirtualNetworkDefinition @splat

# Windows 11
$splat = @{
    VirtualSwitch  = 'NATSwitch'
    UseDhcp       = $true
}
$netAdapter = New-LabNetworkAdapterDefinition @splat
$splat = @{
    Name            = 'SimpleLabWin11'
    NetworkAdapter  = $netAdapter
}
Add-LabMachineDefinition @splat

Install-Lab

Show-LabDeploymentSummary
