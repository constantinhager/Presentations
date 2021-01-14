Clear-AzContext -Scope Process
Clear-AzContext -Scope CurrentUser -Force -ErrorAction SilentlyContinue

$password = ConvertTo-SecureString -String "$env:ClientSecret" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$env:ClientID", $password
Connect-AzAccount -ServicePrincipal -Tenant "$env:TenantID" -Credential $Cred
Set-AzContext -SubscriptionId "$env:SubscriptionID" -TenantId "$env:TenantID"