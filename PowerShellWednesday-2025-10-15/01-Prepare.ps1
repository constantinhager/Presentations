Install-PSResource -Name Pester -TrustRepository -Scope AllUsers
Install-PSResource -Name AutomatedLab -NoClobber -TrustRepository -Scope AllUsers

# Pre-configure telemetry
[Environment]::SetEnvironmentVariable('AUTOMATEDLAB_TELEMETRY_OPTIN', 'false', 'Machine')
$env:AUTOMATEDLAB_TELEMETRY_OPTIN = 'false'

# Pre-configure Lab Host Remoting
Enable-LabHostRemoting -Force

# Windows
New-LabSourcesFolder -DriveLetter E

# Set Some Settings
Set-PSFConfig -Module AutomatedLab -Name LabAppDataRoot -Value "E:\AutomatedLab" -PassThru | Register-PSFConfig
Set-PSFConfig -Module AutomatedLab -Name DiskDeploymentInProgressPath -Value 'E:\AutomatedLab\LabDiskDeploymentInProgress.txt' -PassThru | Register-PSFConfig
Set-PSFConfig -Module AutomatedLab -Name ProductKeyFilePath -Value 'E:\AutomatedLab\Assets\ProductKeys.xml' -PassThru | Register-PSFConfig
Set-PSFConfig -Module AutomatedLab -Name ProductKeyFilePathCustom -Value 'E:\AutomatedLab\Assets\ProductKeysCustom.xml' -PassThru | Register-PSFConfig
Set-PSFConfig -Module AutomatedLab -Name SwitchDeploymentInProgressPath -Value 'E:\AutomatedLab\VSwitchDeploymentInProgress.txt' -PassThru | Register-PSFConfig
Set-PSFConfig -Module AutomatedLab -Name VmPath -Value 'E:\AutomatedLab-Vms' -PassThru | Register-PSFConfig
