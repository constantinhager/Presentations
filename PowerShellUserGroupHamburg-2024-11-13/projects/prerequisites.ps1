wsl --install

winget install Microsoft.PowerShell
winget install Microsoft.VisualStudioCode.Insiders
winget install Git.Git
winget install Docker.DockerDesktop

# configure git
git config --global user.name '<your name>'
git config --global user.email '<your email>'

# Create needed Folders inside of PSUAdvanced and PSUSimple
$path_psusimple_data = [System.IO.Path]::Combine($PSScriptRoot, 'PSUSimple', 'data')
$path_psuadv_data = [System.IO.Path]::Combine($PSScriptRoot, 'PSUAdvanced', 'data')
$path_psuadv_datafiles = [System.IO.Path]::Combine($PSScriptRoot, 'PSUAdvanced', 'datafiles')

New-Item -ItemType Directory -Path $path_psusimple_data -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $path_psuadv_data -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $path_psuadv_datafiles -ErrorAction SilentlyContinue
