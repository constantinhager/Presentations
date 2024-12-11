$Navigation = @(
    New-UDListItem -Label 'UserManagement'
)

$Pages = @()
$Pages = New-UDPage -Name 'UserManagement' -Icon (New-UDIcon -Icon 'User') -Url '/usermanagement' -Content {
    New-CHUserManagementPage
} -Navigation $Navigation -NavigationLayout Permanent

New-UDApp -Pages $Pages
