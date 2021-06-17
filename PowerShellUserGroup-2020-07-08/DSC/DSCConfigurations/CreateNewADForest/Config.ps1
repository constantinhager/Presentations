param
(
    # Parameter help description
    [Parameter(Mandatory)]
    [String]
    $OutputPath
)

configuration CreateNewADForest
{
    Import-DscResource -ModuleName ActiveDirectoryDSC
    Import-DscResource -ModuleName ComputerManagementDSC
    Import-DscResource -ModuleName StorageDSC
    Import-DscResource -ModuleName xPSDesiredStateConfiguration

    $DomainAdminCredential = Get-AutomationPSCredential -Name "DomainAdminCredential"
    $SafeModeCredential = Get-AutomationPSCredential -Name "SafeModeCredential"
    $DomainName = Get-AutomationVariable -Name "DomainName"

    node localhost
    {
        WindowsFeature ADDSInstall
        {
            Ensure = 'Present'
            Name   = 'AD-Domain-Services'
        }

        WindowsFeature 'InstallADDomainServicesFeature'
        {
            Ensure    = 'Present'
            Name      = 'AD-Domain-Services'
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

        WindowsFeature 'RSATADPowerShell'
        {
            Ensure    = 'Present'
            Name      = 'RSAT-AD-PowerShell'

            DependsOn = '[WindowsFeature]InstallADDomainServicesFeature'
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
            DriveLetter = "E"
            DependsOn   = '[WaitForDisk]Disk'
        }

        PendingReboot BeforeDC
        {
            Name             = 'BeforeDC'
            SkipCcmClientSDK = $true
            DependsOn        = '[WindowsFeature]ADDSInstall', '[Disk]DomainDataVolume'
        }

        ADDomain CreateDomain
        {
            DomainName                    = $DomainName
            Credential                    = $DomainAdminCredential
            SafeModeAdministratorPassword = $SafeModeCredential
            DatabasePath                  = "E:\NTDS"
            LogPath                       = "E:\NTDS"
            SysvolPath                    = "E:\SYSVOL"
            DependsOn                     = '[WindowsFeature]ADDSInstall', '[Disk]DomainDataVolume', '[PendingReboot]BeforeDC'
            ForestMode                    = 'WinThreshold'
        }
    }
}

CreateNewADForest -OutputPath $OutputPath