Write-Output "Get Storage Account with plaintext variable"
Get-AzStorageAccount -Name $env:StorageAccountName -ResourceGroupName "WVD"

Write-Output "Get Storage Account with secret variable"
Get-AzStorageAccount -Name $env:StorageAccountNameSecret -ResourceGroupName "WVD"