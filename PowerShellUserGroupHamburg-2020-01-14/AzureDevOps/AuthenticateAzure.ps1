[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $ClientSecret,

    [Parameter(Mandatory)]
    [string]
    $ClientId,

    [Parameter(Mandatory)]
    [string]
    $TenantID,

    [Parameter(Mandatory)]
    [string]
    $SubscriptionID
)

Clear-AzContext -Scope Process
Clear-AzContext -Scope CurrentUser -Force -ErrorAction SilentlyContinue

$password = ConvertTo-SecureString -String "$ClientSecret" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$ClientID", $password
Connect-AzAccount -ServicePrincipal -Tenant "$TenantID" -Credential $Cred
Set-AzContext -SubscriptionId "$SubscriptionID" -TenantId "$TenantID"