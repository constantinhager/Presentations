param
(
    [Parameter(Mandatory)]
    [String]
    $OutputPath,

    [Parameter(Mandatory)]
    [string]
    $SafeModepwd,

    [Parameter(Mandatory)]
    [string]
    $DomainAdmin,

    [Parameter(Mandatory)]
    [string]
    $DomainAdminPwd,

    [Parameter(Mandatory)]
    [string]
    $DomainName
)

configuration AddDCToExistingForest
{
    param
    (
        [Parameter(Mandatory)]
        [pscredential]
        $DomainAdminCredential,

        [Parameter(Mandatory)]
        [pscredential]
        $SafeModeCredential,

        [Parameter(Mandatory)]
        [string]
        $DomainName
    )


    Import-DscResource -ModuleName ActiveDirectoryDSC
    Import-DscResource -ModuleName ComputerManagementDSC
    Import-DscResource -ModuleName StorageDSC
    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    node localhost
    {
        WindowsFeature ADDSInstall {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        WaitForDisk Disk
        {
            DiskId           = 2
            RetryIntervalSec = 10
            RetryCount       = 30
        }

        Disk DomainDataVolume
        {
            DiskId      = 2
            DriveLetter = 'E'
            DependsOn   = '[WaitForDisk]Disk'
        }

        PendingReboot BeforeDC
        {
            Name             = 'BeforeDC'
            SkipCcmClientSDK = $true
            DependsOn        = '[WindowsFeature]ADDSInstall', '[Disk]DomainDataVolume'
        }

        WindowsFeature 'InstallADDomainServicesFeature' {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        WindowsFeature 'RSATADPowerShell' {
            Ensure    = 'Present'
            Name      = 'RSAT-AD-PowerShell'

            DependsOn = '[WindowsFeature]InstallADDomainServicesFeature'
        }

        WaitForADDomain 'WaitForestAvailability'
        {
            DomainName = $DomainName
            Credential = $DomainAdminCredential

            DependsOn  = '[WindowsFeature]RSATADPowerShell'
        }

        ADDomainController 'DomainControllerAllProperties'
        {
            DomainName                    = $DomainName
            Credential                    = $DomainAdminCredential
            SafeModeAdministratorPassword = $SafeModeCredential
            DatabasePath                  = 'E:\NTDS'
            LogPath                       = 'E:\NTDS'
            SysvolPath                    = 'E:\SYSVOL'
            SiteName                      = 'Default-First-Site-Name'
            IsGlobalCatalog               = $true
            InstallDns                    = $true
            DependsOn                     = '[WaitForADDomain]WaitForestAvailability'
        }
    }
}

$DomainAdminSecure = ConvertTo-SecureString -String $DomainAdminPwd -Force -AsPlainText
$SafeModeSecure = ConvertTo-SecureString -String $SafeModepwd -Force -AsPlainText

$DomainAdminCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainAdmin, $DomainAdminSecure
$SafeModeCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'DO_NOT_USE', $SafeModeSecure

$splat = @{
    DomainAdminCredential = $DomainAdminCredential
    OutputPath            = $OutputPath
    SafeModeCredential    = $SafeModeCredential
    DomainName            = $DomainName
}

AddDCToExistingForest @splat