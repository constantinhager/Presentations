data "azurerm_automation_account" "aadsc" {
  name                = var.aadsc_name
  resource_group_name = var.aadsc_rg
}

data "azurerm_subnet" "psugvnet" {
  name                 = "psug-snet"
  virtual_network_name = "psug-vnet"
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

  public_ip_name       = "dc-pip"
  location             = "West Europe"
  resource_group_name  = module.ResourceGroup.resource_group_name
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
  resource_group_name                            = module.ResourceGroup.resource_group_name
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
  resource_group_name   = module.ResourceGroup.resource_group_name
  tag_function          = "Availability Set for DCs"
  tag_application       = "AD Controller"
  tag_applicationowner  = "Constantin Hager"
  tag_department        = "IT"
  tag_location          = "West Europe"
}

module "dc" {
  source = "../../../global/virtualmachinewindowsfrommarketplace"

  virtual_machine_name = "dc"
  resource_group_name  = module.ResourceGroup.resource_group_name
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
  resource_group_name  = module.ResourceGroup.resource_group_name
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

resource "azurerm_virtual_machine_extension" "antimalewareextension" {
  name                       = "dcaadsc"
  virtual_machine_id         = module.dc.windows_virtual_machine_id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.75"
  auto_upgrade_minor_version = true

  protected_settings = <<PROTECTED_SETTINGS
        {
          "Items": {
            "registrationKeyPrivate": "${data.azurerm_automation_account.aadsc.primary_key}"
          }
        }
PROTECTED_SETTINGS

  settings = <<SETTINGS
        "Properties": [
            {
              "Name": "RegistrationKey",
              "Value": {
                "UserName": "PLACEHOLDER_DONOTUSE",
                "Password": "PrivateSettingsRef:registrationKeyPrivate"
              },
              "TypeName": "System.Management.Automation.PSCredential"
            },
            {
              "Name": "RegistrationUrl",
              "Value": "${data.azurerm_automation_account.aadsc.endpoint}",
              "TypeName": "System.String"
            },
            {
              "Name": "NodeConfigurationName",
              "Value": "CreateNewADForest.CreateNewADForest",
              "TypeName": "System.String"
            },
            {
              "Name": "ConfigurationMode",
              "Value": "ApplyandAutoCorrect",
              "TypeName": "System.String"
            },
            {
              "Name": "RebootNodeIfNeeded",
              "Value": true,
              "TypeName": "System.Boolean"
            },
            {
              "Name": "ActionAfterReboot",
              "Value": "ContinueConfiguration",
              "TypeName": "System.String"
            }
          ]
SETTINGS

  tags = {
    tag_function         = "AADSC Extension"
    tag_application      = "AADSC Extension for AD Controller"
    tag_applicationowner = "Constantin Hager"
    tag_department       = "IT"
    tag_location         = "West Europe"
  }
}
