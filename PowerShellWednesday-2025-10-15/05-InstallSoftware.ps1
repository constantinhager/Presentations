$labName = 'PSWedInstallSoftwareLab'

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
    VirtualSwitch = 'NATSwitch'
    UseDhcp       = $true
}
$netAdapter = New-LabNetworkAdapterDefinition @splat
$splat = @{
    Name           = 'InstallSWWin11'
    NetworkAdapter = $netAdapter
}
Add-LabMachineDefinition @splat

Install-Lab

# Install software 7-Zip
# If you want to download the file via Powershell from the internet with AL use
# Get-LabInternetFile -Uri 'https://www.7-zip.org/a/7z2501-x64.msi' -DestinationPath "$labSources\SoftwarePackages\7z2501-x64.msi"
$Parameters = @{
    ComputerName = 'InstallSWWin11'
    Path         = "$labSources\SoftwarePackages\7z2501-x64.msi"
    CommandLine  = '/q'
}
Install-LabSoftwarePackage @Parameters

Show-LabDeploymentSummary
