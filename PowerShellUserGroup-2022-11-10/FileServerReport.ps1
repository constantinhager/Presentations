$FSReportRoot = 'C:\SampleFS'
$FSReportRootArray = New-Object -TypeName 'System.Collections.Generic.List[System.Object]'

#region Access Report for Report Root
$FSReportRoot = Get-Item -Path $FSReportRoot
$AccessReport = Get-NTFSAccess -Path $FSReportRoot.FullName
$InheritanceReport = Get-NTFSInheritance -Path $FSReportRoot.FullName
$OwnerReport = Get-NTFSOwner -Path $FSReportRoot.FullName
foreach ($ace in $AccessReport) {
    $row = [PSCustomObject]@{
        FolderPath         = $FSReportRoot.FullName
        OwnerSID           = $OwnerReport.Account.Sid
        OwnerName          = $OwnerReport.Account.AccountName
        AccountSID         = $ace.Account.Sid
        AccountName        = $ace.Account.AccountName
        AccessRights       = $ace.AccessRights
        AccessControlType  = $ace.AccessControlType
        PropagationFlags   = $ace.PropagationFlags
        InheritanceFlags   = $ace.InheritanceFlags
        InheritanceEnabled = $InheritanceReport.AccessInheritanceEnabled
        IsInherited        = $ace.IsInherited
        IsInheritedFrom    = $ace.InheritedFrom
    }
    $FSReportRootArray.Add($row)
}
#endregion

#region Access Report for subfolders
$AllFolders = Get-ChildItem -Path $FSReportRoot -Recurse

foreach ($folder in $AllFolders) {
    $AccessReport = Get-NTFSAccess -Path $folder.FullName
    $InheritanceReport = Get-NTFSInheritance -Path $folder.FullName
    $OwnerReport = Get-NTFSOwner -Path $folder.FullName

    foreach ($ace in $AccessReport) {
        $row = [PSCustomObject]@{
            FolderPath         = $folder.FullName
            OwnerSID           = $OwnerReport.Account.Sid
            OwnerName          = $OwnerReport.Account.AccountName
            AccountSID         = $ace.Account.Sid
            AccountName        = $ace.Account.AccountName
            AccessRights       = $ace.AccessRights
            AccessControlType  = $ace.AccessControlType
            PropagationFlags   = $ace.PropagationFlags
            InheritanceFlags   = $ace.InheritanceFlags
            InheritanceEnabled = $InheritanceReport.AccessInheritanceEnabled
            IsInherited        = $ace.IsInherited
            IsInheritedFrom    = $ace.InheritedFrom
        }
        $FSReportRootArray.Add($row)
    }
}
#endregion

#region Generate Excel Report
$Parameters = @{
    Path          = 'C:\FSReport.xlsx'
    WorksheetName = 'FSReport'
    AutoSize      = $true
    AutoFilter    = $true
    FreezeTopRow  = $true
    TableStyle    = 'Light1'
    ClearSheet    = $true
}
$FSReportRootArray | Export-Excel @Parameters
#endregion