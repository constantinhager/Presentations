param(
    [Parameter()]
    [int]
    $Page = 1
)

$data = Invoke-RestMethod -Uri "http://reqres.in/api/users?page=$Page" -Method GET
$data | ConvertTo-Json
