module "ResourceGroup" {
  source = "../../global/ResourceGroup"

  resource_group_name = var.rg_name
  tag_creator         = "Constantin Hager"
  tag_function        = "Azure Automation DSC"
  location            = "West Europe"
}

module "virtualnetwork" {
  source               = "../../global/virtualnetwork"
  location             = "West Europe"
  resource_group_name  = var.rg_name
  virtual_network_name = "psug-vnet"
  address_space        = ["172.20.0.0/16"]
  dns_servers          = ["172.20.1.10"]
  tag_function         = "PSUG VNet"
  tag_application      = "Virtual Network PSUG"
  tag_applicationowner = "Constantin Hager"
  tag_department       = "IT"
  tag_location         = "West Europe"
}
module "psug-snet" {
  source               = "../../global/subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = module.virtualnetwork.vnet_name
  subnet_name          = "psug-snet"
  address_prefixes     = ["172.20.1.0/24"]
}
