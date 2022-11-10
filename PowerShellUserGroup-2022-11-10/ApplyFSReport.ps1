$FSReportPath = 'C:\FSReport.xlsx' # Change this appropriately

$excel = Import-Excel -Path $FSReportPath

foreach ($entry in $excel) {
    # Set owner
    $Parameters = @{
        Path    = $entry.FolderPath
        Account = $entry.OwnerName
    }
    Set-NTFSOwner @Parameters

    # Set ntfs right
    $Parameters = @{
        Path             = $entry.FolderPath
        Account          = $entry.AccountName
        AccessRights     = $entry.AccessRights
        AccessType       = $entry.AccessControlType
        InheritanceFlags = $entry.InheritanceFlags
        PropagationFlags = $entry.PropagationFlags
    }
    Add-NTFSAccess @Parameters

    # do we need to have inheritance disabled?
    if ($entry.InheritanceEnabled -eq $false) {
        $Parameters = @{
            Path                       = $entry.FolderPath
            RemoveInheritedAccessRules = $true
        }
        Disable-NTFSAccessInheritance @Parameters
    }
}