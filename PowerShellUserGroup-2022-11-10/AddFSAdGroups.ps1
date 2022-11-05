New-ADOrganizationalUnit -Name AdminGroups

$Parameters = @{
    Name          = 'DL-FSAdmins'
    GroupCategory = 'Security'
    GroupScope    = 'DomainLocal'
    Path          = 'OU=AdminGroups,DC=psugntfs,DC=net'
}
New-ADGroup @Parameters

$Parameters = @{
    Name          = 'G-FSAdmins'
    GroupCategory = 'Security'
    GroupScope    = 'Global'
    DisplayName   = 'G-FSAdmins'
    Path          = 'OU=AdminGroups,DC=psugntfs,DC=net'
}
New-ADGroup @Parameters

$Parameters = @{
    Identity = 'DL-FSAdmins'
    Members  = 'G-FSAdmins'
}
Add-ADGroupMember @Parameters

$Parameters = @{
    Identity = 'G-FSAdmins'
    Members  = 'Albania'
}
Add-ADGroupMember @Parameters

$Parameters = @{
    Identity = 'G-FSAdmins'
    Members  = 'Install'
}
Add-ADGroupMember @Parameters

$Parameters = @{
    Name          = 'DL-FSUsers'
    GroupCategory = 'Security'
    GroupScope    = 'DomainLocal'
    Path          = 'OU=Lab Accounts,DC=psugntfs,DC=net'
}
New-ADGroup @Parameters

$Parameters = @{
    Identity = 'DL-FSUsers'
    Members  = 'AllTestUsers'
}
Add-ADGroupMember @Parameters