data "azurerm_subnet" "subnet" {
  name                 = var.snet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.subnet_rg
}

#################################################################################

module "ResourceGroup" {
  source = "../../global/ResourceGroup"

  resource_group_name = var.rg_name
  tag_creator         = "Constantin Hager"
  tag_function        = "NSGs"
  location            = "West Europe"
}


#################################################################################

module "network_security_group" {
  source = "../../global/networksecuritygroup"

  network_security_group_name = var.nsg_name
  location                    = "West Europe"
  resource_group_name         = module.ResourceGroup.resource_group_name
  tag_function                = "NSG for ${var.snet_name}"
  tag_application             = "NSG"
  tag_applicationowner        = "Constantin Hager"
  tag_department              = "IT"
  tag_location                = "West Europe"
}

module "allow_3389_in" {
  source = "../../global/networksecurityrule"

  network_security_rule_name  = "Allow3389"
  resource_group_name         = module.ResourceGroup.resource_group_name
  network_security_group_name = module.psug_network_security_group.network_securtiy_group_name
  description                 = "Allow3389"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  access                      = "Allow"
  priority                    = 100
  direction                   = "Inbound"
}

module "nsg_snet" {
  source = "../../global/netorksecuritygrouptosubnet"

  subnet_id                 = data.azurerm_subnet.subnet.id
  network_security_group_id = module.network_security_group.network_security_group_id
}
