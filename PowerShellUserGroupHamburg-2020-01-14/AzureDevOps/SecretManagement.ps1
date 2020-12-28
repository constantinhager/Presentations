Install-Module -Name Microsoft.PowerShell.SecretManagement -AllowPrerelease -Force

Register-SecretVault -Name AzKeyVault -ModuleName Az.KeyVault -VaultParameters @{
    AZKVaultName   = $env:AZKeyVaultName
    SubscriptionId = $env:SubscriptionID
}

$Secret = Get-Secret -Name "AppInstallStorageAccountName" -Vault AzKeyVault -AsPlainText

# PlainText (only available inside the job)
Write-Output "##vso[task.setvariable variable=PSUGPlainText]$Secret"

# Secure (only available inside the job)
Write-Output "##vso[task.setvariable issecret=true;variable=PSUGSecretText]$Secret"

# Multijob secret (only available outside of the job)
Write-Output "##vso[task.setvariable issecret=true;isOutput=true;variable=PSUGMultiJobSecret]$Secret"

# Multijob non-secret (only available outside of the job)
Write-Output "##vso[task.setvariable isOutput=true;variable=PSUGMultiJobNonSecret]$Secret"