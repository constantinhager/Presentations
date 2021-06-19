data "azurerm_subnet" "psugvnet" {
  name                 = "psug-snet"
  virtual_network_name = "psug-vnet"
  resource_group_name  = var.rg_name
}

data "azurerm_storage_account" "diagstore" {
  name                = "workshopdiag269"
  resource_group_name = "WorkShop"
}

module "publicip_mgmt_dc" {
  source = "../../../global/publicipdnslabel"

  public_ip_name       = "dc-pip"
  location             = "West Europe"
  resource_group_name  = var.rg_name
  allocation_method    = "Static"
  sku                  = "Standard"
  domain_name_label    = "dc-pip"
  tag_function         = "public ip for dc"
  tag_application      = "dc"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "dc_nic" {
  source = "../../../global/publicnetworkinterface"

  private_network_interface_name                 = "dc-nic01"
  location                                       = "West Europe"
  resource_group_name                            = var.rg_name
  enable_ip_forwarding                           = false
  enable_accelerated_networking                  = false
  ip_configuration_name                          = "ipconfig1"
  ip_configuration_subnet_id                     = data.azurerm_subnet.psugvnet.id
  ip_configuration_private_ip_address_allocation = "Static"
  ip_configuration_primary                       = false
  ip_configuration_private_ip_address            = "172.20.1.10"
  ip_configuration_public_ip_address_id          = module.publicip_mgmt_dc.public_ip_address_id
  tag_function                                   = "NIC for dc"
  tag_application                                = "DC"
  tag_applicationowner                           = "Constantin Hager"
  tag_department                                 = "IT"
  tag_location                                   = "West Europe"
}


module "availabilityset" {
  source = "../../../global/availabilityset"

  availability_set_name = "ad-av"
  location              = "West Europe"
  managed               = true
  resource_group_name   = var.rg_name
  tag_function          = "Availability Set for DCs"
  tag_application       = "AD Controller"
  tag_applicationowner  = "Constantin Hager"
  tag_department        = "IT"
  tag_location          = "West Europe"
}

module "dc" {
  source = "../../../global/virtualmachinewindowsfrommarketplace"

  virtual_machine_name = "dc"
  resource_group_name  = var.rg_name
  location             = "West Europe"
  size                 = "Standard_B2ms"

  admin_username = "azureuser"
  admin_password = "Pa$$w0rd!"

  time_zone                            = "W. Europe Standard Time"
  availablility_set_id                 = module.availabilityset.availability_set_id
  network_interface_ids                = module.dc_nic.private_network_interface_id
  boot_diagnostics_storage_account_uri = data.azurerm_storage_account.diagstore.primary_blob_endpoint

  os_disk_size_gb = 127
  os_disk_name    = "dc-osdisk"

  tag_function         = "DC"
  tag_application      = "AD Controller"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "addatadisk" {
  source = "../../../global/manageddiskempty"

  disk_size_gb         = 32
  location             = "West Europe"
  managed_disk_name    = "dc-datadisk01"
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  tag_function         = "dc Datadisk"
  tag_application      = "AD Controller Datadisk"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "addatadiskattachment" {
  source             = "../../../global/datadiskattachment"
  caching            = "None"
  managed_disk_id    = module.addatadisk.managed_disk_id
  lun                = 0
  virtual_machine_id = module.dc.windows_virtual_machine_id
}
/*
resource "azurerm_virtual_machine_extension" "antimalewareextension" {
  name                 = "azeuwsvr001WindowsDefender"
  virtual_machine_id   = module.azeuwsvr001.windows_virtual_machine_id
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

module "BackupVM-azeuwsvr001" {
  source = "../../../global/backupvm"

  resource_group_name = "backup-rg"
  recovery_vault_name = "creatonvmbackup-rsv"
  source_vm_id        = module.azeuwsvr001.windows_virtual_machine_id
  backup_policy_id    = "/subscriptions/b4d67e10-7f66-4ba6-9b04-760f928e9f1d/resourceGroups/backup-rg/providers/Microsoft.RecoveryServices/vaults/creatonvmbackup-rsv/backupPolicies/DefaultPolicy"
}
*/