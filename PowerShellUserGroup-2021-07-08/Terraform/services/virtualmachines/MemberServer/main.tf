data "azurerm_subnet" "creatonvnet" {
  name                 = "Infrastructure-Services-snet"
  virtual_network_name = "creaton-vnet"
  resource_group_name  = "network-rg"
}

data "azurerm_storage_account" "diagstore" {
  name                = "creatondiagstor01"
  resource_group_name = "storageaccounts-rg"
}

data "azurerm_availability_set" "availabilityset" {
  name                = "ad-av"
  resource_group_name = "ad-rg"
}

module "privatenetworkinterface_primary" {
  source = "../../../global/privatenetworkinterface"

  private_network_interface_name      = "azeuwsvr002-nic01"
  ip_configuration_name               = "ipconfig1"
  ip_configuration_primary            = true
  ip_configuration_private_ip_address = "10.50.2.5"

  ip_configuration_subnet_id = data.azurerm_subnet.creatonvnet.id

  dns_servers = ["10.50.2.4", "10.50.2.5"]

  resource_group_name  = "ad-rg"
  location             = "West Europe"
  tag_function         = "NIC for AD Controller"
  tag_application      = "AD Controller"
  tag_applicationowner = "COC AG"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "azeuwsvr002" {
  source = "../../../global/virtualmachinewindowsfrommarketplace"

  virtual_machine_name = "azeuwsvr002"
  resource_group_name = "ad-rg"
  location = "West Europe"
  size = "Standard_B2ms"

  admin_username = "azureuser"
  admin_password = "Creaton!COC2021"

  time_zone = "W. Europe Standard Time"
  availablility_set_id  = data.azurerm_availability_set.availabilityset.id
  network_interface_ids = module.privatenetworkinterface_primary.private_network_interface_id
  boot_diagnostics_storage_account_uri = data.azurerm_storage_account.diagstore.primary_blob_endpoint

  os_disk_size_gb = 127
  os_disk_name    = "azeuwsvr002-osdisk"

  tag_function         = "Second Domain Controller for Creaton"
  tag_application      = "AD Controller"
  tag_applicationowner = "COC AG"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "addatadisk" {
  source = "../../../global/manageddiskempty"

  disk_size_gb         = 32
  location             = "West Europe"
  managed_disk_name    = "azeuwsvr002-datadisk01"
  resource_group_name  = "ad-rg"
  storage_account_type = "Standard_LRS"
  tag_function         = "azeuwsvr002 Datadisk"
  tag_application      = "AD Controller Datadisk"
  tag_applicationowner = "COC AG"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "addatadiskattachment" {
  source             = "../../../global/datadiskattachment"
  caching            = "None"
  managed_disk_id    = module.addatadisk.managed_disk_id
  lun                = 0
  virtual_machine_id = module.azeuwsvr002.windows_virtual_machine_id
}

resource "azurerm_virtual_machine_extension" "antimalewareextension" {
  name                 = "azeuwsvr002WindowsDefender"
  virtual_machine_id   = module.azeuwsvr002.windows_virtual_machine_id
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.3"

  settings = <<SETTINGS
        {
          "AntimalwareEnabled": "true",
          "RealtimeProtectionEnabled": "true",
          "ScheduledScanSettings": {
            "isEnabled": "true",
            "scanType": "Quick",
            "day": "7",
            "time": "120"
          }
        }
SETTINGS

  tags = {
    tag_function         = "Windows Defender VM Extension"
    tag_application      = "Windows Defender VM Extension for AD Controller"
    tag_applicationowner = "COC AG"
    tag_department       = "IT"
    tag_location         = "West Europe"
  }
}

module "BackupVM-azeuwsvr002" {
  source = "../../../global/backupvm"

  resource_group_name = "backup-rg"
  recovery_vault_name = "creatonvmbackup-rsv"
  source_vm_id        = module.azeuwsvr002.windows_virtual_machine_id
  backup_policy_id    = "/subscriptions/b4d67e10-7f66-4ba6-9b04-760f928e9f1d/resourceGroups/backup-rg/providers/Microsoft.RecoveryServices/vaults/creatonvmbackup-rsv/backupPolicies/DefaultPolicy"
}
