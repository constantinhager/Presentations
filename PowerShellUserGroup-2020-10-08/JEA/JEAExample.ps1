# Ich verbinde mich auf den Standardentpunkt
Enter-PSSession -ComputerName DC2

# Zeige mir alle Commands an
Get-Command # Habe alle Kommandos zur Verfügung

# Gehe in das Filesystem
Set-Location C:\Windows # sollte aber nicht jeder dürfen

# Wie schrenke ich jetzt das ein?
# Antwort JEA

#region JEA

# Szenario:
# Es sollen zwei Rollen definiert werden:
# DNS Admin: Darf den DNS-Server Service neu starten, ping und whoami ausführen und zusätzlich alle Rechte die der Rolle DNS Viewer zugewießen worden sind
# DNS Viewer: Darf alle DNSServer Get Functions aus dem Module DNS Server abrufen.
#             Darf eine selbst geschriebene Funktion die das Microsoft-Windows-Dns-Server-Service Eventlog abfragt aufrufen.

#region Module / RoleCapabiltyFile für JEA erstellen

# 1. Ordnerstruktur für Modul erstellen
# Create a folder for the module
$modulePath = Join-Path '\\dc2\C$\Program Files' 'WindowsPowerShell\Modules\DNSMaintenance'

if (-not(Test-Path -Path $modulePath))
{
    New-Item -ItemType Directory -Path $modulePath
}

# Create an empty script module and module manifest. At least one file in the module folder must have the same name as the folder itself.
New-Item -ItemType File -Path (Join-Path $modulePath 'DNSMaintenance.psm1')
New-ModuleManifest -Path (Join-Path $modulePath 'DNSMaintenance.psd1') -RootModule 'DNSMaintenance.psm1'

# Create the RoleCapabilities folder and create role capability Files
$rcFolder = Join-Path $modulePath 'RoleCapabilities'
if (-not(Test-Path -Path $rcFolder))
{
    New-Item -ItemType Directory $rcFolder
}

# Create the DNS Viewer role capability
$dnsEventFnDef = @{
    Name        = 'Get-DnsServerLog'
    ScriptBlock = { param([long]$MaxEvents = 100) Get-WinEvent -ProviderName "Microsoft-Windows-Dns-Server-Service" -MaxEvents $MaxEvents }
}

$param_psrc = @{
    Path                = (Join-Path -Path $rcFolder -ChildPath 'DnsViewer.psrc')
    VisibleFunctions    = "DnsServer\Get-*", "Get-DnsServerLog"
    FunctionDefinitions = $dnsEventFnDef
}

New-PSRoleCapabilityFile @param_psrc


$param_psrc = @{
    Path                    = (Join-Path -Path $rcFolder -ChildPath 'DnsAdmin.psrc')
    VisibleCmdlets          = @{ Name = 'Restart-Service'; Parameters = @{ Name = 'Name'; ValidateSet = 'Dns' } }
    VisibleExternalCommands = 'C:\Windows\System32\ping.exe', 'C:\Windows\System32\whoami.exe'
}

New-PSRoleCapabilityFile @param_psrc

# psrc anzeigen lassen
psedit (Join-Path -Path $rcFolder -ChildPath 'DnsAdmin.psrc')
psedit (Join-Path -Path $rcFolder -ChildPath 'DnsViewer.psrc')

#endregion

#region Erstellen eines SessionConfiguration Files

# 0. Transcriptsordner erstellen

if (-not(Test-Path -Path "\\DC2\c$\JEA\Transcripts"))
{
    New-Item -ItemType Directory -Path \\DC2\c$\JEA -Name Transcripts
}

$viewerGroup = "WORKSHOP\JEA_DNSMaintenance_Viewer"
$adminGroup = "WORKSHOP\JEA_DNSMaintenance_Admin"

# 1. Erstellen des PSSessionConfiguration Files
if (-not(Test-Path -Path "\\DC2\c$\ProgramData\JEAConfiguration"))
{
    New-Item -ItemType Directory -Path \\DC2\c$\ProgramData\JEAConfiguration
}

$param_roledefenition = @{
    Path                = '\\DC2\c$\ProgramData\JEAConfiguration\DNSMaintenance.pssc'
    SessionType         = 'RestrictedRemoteServer'
    LanguageMode        = 'NoLanguage'
    TranscriptDirectory = 'C:\JEA\Transcripts'
    RoleDefinitions     = @{
        $viewerGroup = @{ RoleCapabilities = 'DnsViewer' };
        $adminGroup  = @{ RoleCapabilities = 'DnsViewer', 'DnsAdmin' }
    }
    RunAsVirtualAccount = $true
}

New-PSSessionConfigurationFile @param_roledefenition

#endregion

#region Erstellen des PowerShell Endpoints
# 1. Hole Alle SessionConfigurations (Nur zur Übersicht)
Invoke-Command -ComputerName DC2 -ScriptBlock { Get-PSSessionConfiguration }

# 2. Hinzufügen eines neuen Endpunkts
# Pfad zur Session Configuration Files: C:\Temp\Demo.pssc
# Achtung: Es muss der WinRM serive neugestartet werden.
Invoke-Command -ComputerName DC2 -ScriptBlock { Register-PSSessionConfiguration -Name 'DNSMaintenance' -Path "\\DC2\c$\ProgramData\JEAConfiguration\DNSMaintenance.pssc" }

# 4. Verbinden zu diesem Endpunkt (IN RICHTIGER POWERSHELL AUSFÜHREN sonst sessionDetails null Error)
# Speichern der Credentials des Users dnsservice_view
$DNSMaintenance_ViewCred = Get-Credential -UserName 'workshop\dnsservice_viewer' -Message "Please Provide your passsword"
$DNSMaintenance_AdminCred = Get-Credential -UserName 'workshop\dnsservice_admin' -Message "Please Provide your passsword"
Enter-PSSession -ComputerName DC2 -ConfigurationName DNSMaintenance -Credential $DNSMaintenance_ViewCred

# Alle Kommandos anzeigen lassen:
Get-Command

Get-DNSServerLog
Get-DNSServer

Enter-PSSession -ComputerName DC2 -ConfigurationName DNSMaintenance -Credential $DNSMaintenance_AdminCred
# Alle Kommandos anzeigen lassen:
Get-Command

whoami
ping dc2
Restart-Service -Name BITS # Fehlermeldung

#endregion

#endregion