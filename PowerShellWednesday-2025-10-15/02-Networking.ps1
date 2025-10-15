# Create Hyper-V Virtual Switch for NAT Networking
$SwitchName = 'NATSwitch'
$SwitchNameAD = 'ADNatSwitch'
$GatewayIP = '192.168.100.1'
$GatewayIPAD = '192.168.80.1'
$ScopeID = '192.168.100.0'
$ScopeIDAD = '192.168.80.0'
$DnsServer = '168.63.129.16'
$DnsServerAD = '192.168.80.10'

New-VMSwitch -Name $SwitchName -SwitchType Internal
New-NetIPAddress -IPAddress $GatewayIP -PrefixLength 24 -InterfaceAlias ('vEthernet (' + $SwitchName + ')')

New-VMSwitch -Name $SwitchNameAD -SwitchType Internal
New-NetIPAddress -IPAddress $GatewayIPAD -PrefixLength 24 -InterfaceAlias ('vEthernet (' + $SwitchNameAD + ')')

# Configure NAT
New-NetNat -Name NATInternal -InternalIPInterfaceAddressPrefix $GatewayIP/24
New-NetNat -Name NATInternalAD -InternalIPInterfaceAddressPrefix $GatewayIPAD/24

# Add DHCP Server to provide IP addresses to VMs
$Parameters = @{
    Name        = 'NATScope'
    Description = 'NAT Scope for VMs'
    SubnetMask  = '255.255.255.0'
    StartRange  = '192.168.100.10'
    EndRange    = '192.168.100.100'
}
Add-DhcpServerv4Scope @Parameters

$Parameters = @{
    Name        = 'NATScopeAD'
    Description = 'NAT Scope for AD VMs'
    SubnetMask  = '255.255.255.0'
    StartRange  = '192.168.80.10'
    EndRange    = '192.168.80.100'
}
Add-DhcpServerv4Scope @Parameters

# Set DHCP Options
Set-DhcpServerv4OptionValue -ScopeId $ScopeID -Router $GatewayIP -DnsServer $DnsServer
Set-DhcpServerv4OptionValue -ScopeId $ScopeIDAD -Router $GatewayIPAD -DnsServer $DnsServerAD, $DnsServer -Force
