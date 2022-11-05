$RootFolder = 'C:\SampleFS'
$Marketing = Join-Path $RootFolder -ChildPath 'Marketing'
$MarketingSubFolder1 = Join-Path $Marketing -ChildPath 'Images'
$MarketingSubFolder2 = Join-Path $Marketing -ChildPath 'Campaigns'
$IT = Join-Path -Path $RootFolder -ChildPath 'IT'
$ITSubFolder1 = Join-Path -Path $IT -ChildPath 'Software'
$ITSubFolder2 = Join-Path -Path $IT -ChildPath 'ISOs'
$HR = Join-Path -Path $RootFolder -ChildPath 'HR'
$HRSubFolder1 = Join-Path -Path $HR -ChildPath 'Employee Reviews'
$HRSubFolder2 = Join-Path -Path $HR -ChildPath 'Payments'

if (-not(Test-Path -Path $RootFolder)) {
    New-Item -ItemType Directory -Path $RootFolder
}

if (-not (Get-SmbShare -Name 'SampleFS' -ErrorAction SilentlyContinue)) {
    $Parameters = @{
        ChangeAccess = 'Everyone'
        Path         = $RootFolder
        Name         = 'SampleFS'
    }
    New-SmbShare @Parameters
}

if (-not(Test-Path -Path $Marketing)) {
    New-Item -ItemType Directory -Path $Marketing
}

if (-not(Test-Path -Path $MarketingSubFolder1)) {
    New-Item -ItemType Directory -Path $MarketingSubFolder1
}

if (-not(Test-Path -Path $MarketingSubFolder2)) {
    New-Item -ItemType Directory -Path $MarketingSubFolder2
}

if (-not(Test-Path -Path $IT)) {
    New-Item -ItemType Directory -Path $IT
}

if (-not(Test-Path -Path $ITSubFolder1)) {
    New-Item -ItemType Directory -Path $ITSubFolder1
}

if (-not(Test-Path -Path $ITSubFolder2)) {
    New-Item -ItemType Directory -Path $ITSubFolder2
}

if (-not(Test-Path -Path $HR)) {
    New-Item -ItemType Directory -Path $HR
}

if (-not(Test-Path -Path $HRSubFolder1)) {
    New-Item -ItemType Directory -Path $HRSubFolder1
}

if (-not(Test-Path -Path $HRSubFolder2)) {
    New-Item -ItemType Directory -Path $HRSubFolder2
}