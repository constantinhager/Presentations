#region Install SSH Remoting Windows

# Checke ob OpenSSH instaliert ist
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Invoke-WebRequest -Uri "https://github.com/PowerShell/Win32-OpenSSH/releases/download/v8.1.0.0p1-Beta/OpenSSH-Win32.zip" -OutFile "C:\Temp\OpenSSH-Win32.zip"
Unblock-File -Path "C:\Temp\OpenSSH-Win32.zip"
Expand-Archive -Path "C:\Temp\OpenSSH-Win32.zip" -DestinationPath "C:\Temp"
Rename-Item -Path "C:\Temp\OpenSSH-Win32" -NewName "C:\Temp\OpenSSH"
Copy-Item -Path "C:\Temp\OpenSSH" -Destination "C:\Program Files" -Recurse
& "C:\Program Files\OpenSSH\install-sshd.ps1"

# Ist der Fix in den Built in Windows SSH Server ausgebracht reicht folgendes Commando aus (ssh key mismatch. Ist mit Windows 10 2004 nocht nicht gefixed):
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Installieren der Remoting Tools
Install-Module -Name Microsoft.PowerShell.RemotingTools -Force

# Starten des Services (Standard Startup Type: Manual, nicht gestartet)
Get-Service -Name sshd
Get-Service -Name ssh-agent
Set-Service -Name sshd -StartupType Automatic
Set-Service -Name ssh-agent -StartupType Automatic
Start-Service -Name sshd
Start-Service -Name ssh-agent

# Einrichten / Kofigurieren von SSH Remoting
Enable-SSHRemoting

# Ausgabe beim Einrichten
#WARNING: -SSHDConfigFilePath not provided. Using default configuration file location.
#Validating current PowerShell to use as endpoint subsystem.
#
#Using PowerShell at this path for SSH remoting endpoint:
#C:\PROGRA~1\POWERS~1\7\pwsh.exe
#
#Modifying SSHD configuration file at this location:
#C:\ProgramData\ssh\sshd_config
#
#Enable-SSHRemoting
#The SSHD service configuration file (sshd_config) will now be updated to enable PowerShell remoting over SSH. Do you wish to continue?
#[Y] Yes [N] No [S] Suspend [?] Help (default is "Yes"): Y

# Neustarten des sshd services
Restart-Service -Name sshd

#endregion

#region install SSH Remoting on linux

# Aufbauen einer standard SSH Verbindung zu Centos
ssh azureuser@10.0.0.6

# Installieren von PowerShell in Linux
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
sudo yum install -y powershell
pwsh

# Installieren der Remoting Tools
Install-Module -Name Microsoft.PowerShell.RemotingTools -Force

# Einrichten / Kofigurieren von SSH Remoting
Enable-SSHRemoting

# Ausgabe beim Einrichten
#Enable-SSHRemoting
#This cmdlet must be run as 'root'. If you continue, PowerShell will restart under 'root'. Do you wish to continue?
#[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): y
#WARNING: -SSHDConfigFilePath not provided. Using default configuration file location.
#Validating current PowerShell to use as endpoint subsystem.
#
#Using PowerShell at this path for SSH remoting endpoint:
#/opt/microsoft/powershell/7/pwsh
#
#Modifying SSHD configuration file at this location:
#/etc/ssh/sshd_config
#
#
#Enable-SSHRemoting
#The SSHD service configuration file (sshd_config) will now be updated to enable PowerShell remoting over SSH. Do you wish to continue?
#[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"):

# Anschauen der neuen sshd_config
Get-Content /etc/ssh/sshd_config

# Anschauen des Verzeichnisses ssd
Get-ChildItem /etc/ssh

# Neustarten des sshd services
systemctl stop sshd
systemctl start sshd
#endregion

#region Public key authentication (optional but more secure and no password typing)

#region windows part
Set-Service -Name ssh-agent -StartupType Automatic
Start-Service -Name ssh-agent

# Generate a private key
ssh-keygen.exe

# Hinzufügen des Privaten Schlüssels zum SSH Agent
ssh-add C:\Users\azureuser.WORKSHOP\.ssh\id_rsa

# Verbinden per ssh
ssh azureuser@10.0.0.6

# erstellen des Verzeichnisses .ssh und der Datei authorized_keys mit den standard permissions
(umask 077 && test -d ~/.ssh || mkdir ~/.ssh)
(umask 077 && touch ~/.ssh/authorized_keys)

# im .ssh Verzeichnis eueres users in Windows existiert eine Datei id_rsa.pub. Diese Datei öffnen und den Inhalt der Datei
# in die authorized_keys File am Linux host einfügen.

# ein erneutes verbinden sollte nun keine Passwortabfrage mehr benötigen.

#endregion

#endregion