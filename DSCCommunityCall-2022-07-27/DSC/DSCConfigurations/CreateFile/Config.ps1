param
(
    # Parameter help description
    [Parameter(Mandatory)]
    [String]
    $OutputPath
)

configuration CreateFile {

    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    # One can evaluate expressions to get the node list
    # E.g: $AllNodes.Where("Role -eq Web").NodeName
    node localhost
    {
        File CreateFile
        {
            Type            = 'Directory'
            DestinationPath = 'C:\TestUser3'
            Ensure          = "Present"
        }
    }
}

CreateFile -OutputPath $OutputPath