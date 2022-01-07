data "azurerm_subnet" "subnet" {
  name                 = var.snet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.subnet_rg
}

data "azurerm_storage_account" "diagstore" {
  name                = "workshopdiag269"
  resource_group_name = "WorkShop"
}

module "ResourceGroup" {
  source = "../../../global/ResourceGroup"

  resource_group_name = var.rg_name
  tag_creator         = "Constantin Hager"
  tag_function        = "Azure Automation DSC"
  location            = "West Europe"
}

module "publicip_mgmt_dc" {
  source = "../../../global/publicipdnslabel"

  public_ip_name       = "${var.vm_name}-pip"
  location             = "West Europe"
  resource_group_name  = module.ResourceGroup.resource_group_name
  allocation_method    = "Static"
  sku                  = "Standard"
  domain_name_label    = "${var.vm_name}-pip"
  tag_function         = "public ip for ${var.vm_name}"
  tag_application      = "dc"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "dc_nic" {
  source = "../../../global/publicnetworkinterface"

  private_network_interface_name                 = "${var.vm_name}-nic01"
  location                                       = "West Europe"
  resource_group_name                            = module.ResourceGroup.resource_group_name
  enable_ip_forwarding                           = false
  enable_accelerated_networking                  = false
  ip_configuration_name                          = "ipconfig1"
  ip_configuration_subnet_id                     = data.azurerm_subnet.subnet.id
  ip_configuration_private_ip_address_allocation = "Static"
  ip_configuration_primary                       = false
  ip_configuration_private_ip_address            = "172.20.1.11"
  ip_configuration_public_ip_address_id          = module.publicip_mgmt_dc.public_ip_address_id
  tag_function                                   = "NIC for ${var.vm_name}"
  tag_application                                = "DC"
  tag_applicationowner                           = "Constantin Hager"
  tag_department                                 = "IT"
  tag_location                                   = "West Europe"
}


module "availabilityset" {
  source = "../../../global/availabilityset"

  availability_set_name = "dsce-av"
  location              = "West Europe"
  managed               = true
  resource_group_name   = module.ResourceGroup.resource_group_name
  tag_function          = "Availability Set for DSC Extension VMs"
  tag_application       = "DSC Extension VMs"
  tag_applicationowner  = "Constantin Hager"
  tag_department        = "IT"
  tag_location          = "West Europe"
}

module "dc" {
  source = "../../../global/virtualmachinewindowsfrommarketplace"

  virtual_machine_name = var.vm_name
  resource_group_name  = module.ResourceGroup.resource_group_name
  location             = "West Europe"
  size                 = "Standard_B2ms"

  admin_username = "azureuser"
  admin_password = "Pa$$w0rd!"

  time_zone                            = "W. Europe Standard Time"
  availablility_set_id                 = module.availabilityset.availability_set_id
  network_interface_ids                = module.dc_nic.private_network_interface_id
  boot_diagnostics_storage_account_uri = data.azurerm_storage_account.diagstore.primary_blob_endpoint

  source_image_reference_publisher = "MicrosoftWindowsServer"
  source_image_reference_offer     = "WindowsServer"
  source_image_reference_sku       = "2022-datacenter"

  os_disk_size_gb = 127
  os_disk_name    = "${var.vm_name}-osdisk"

  tag_function         = "DSC Extension VM"
  tag_application      = "DSC Extension VM"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

resource "azurerm_virtual_machine_extension" "aadsc" {

  depends_on = [
    module.addatadiskattachment
  ]

  name                       = "dcaadsc"
  virtual_machine_id         = module.dc.windows_virtual_machine_id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.75"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "ModulesUrl": "https://dscccdscstorage01.blob.core.windows.net/dsc/Config.ps1.zip",
        "SasToken": "?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2022-03-31T16:56:31Z&st=2022-01-06T09:00:31Z&spr=https&sig=ZIKKHG9M5bVDl6g7wPlysO6TVoE0A0Wcfy0Yaq%2FokOg%3D",
        "ConfigurationFunction": "Config.ps1\\CreateFile",
    }
SETTINGS

  tags = {
    tag_function         = "DSC Extension"
    tag_application      = "DSC Extension for DSC Extension VM"
    tag_applicationowner = "Constantin Hager"
    tag_department       = "IT"
    tag_location         = "West Europe"
  }
}
