function parseExtension {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Object[]]
        $Extensions
    )

    $Output = [System.Collections.Generic.List[pscustomobject]]::new()

    foreach ($extension in $Extensions) {
        $row = [PSCustomObject]@{
            ExtensionName    = $extension.Split('@')[0]
            ExtensionVersion = $extension.Split('@')[1]
        }

        $Output.Add($row)
    }
    return $Output
}