param(
    [Parameter(Mandatory)]
    [int]
    $Id
)

$url = "http://reqres.in/api/users/$Id"
$response = Invoke-RestMethod -Uri $url -Method Get
$response | Convertto-Json