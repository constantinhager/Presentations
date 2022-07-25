resource "azurerm_network_interface" "ni" {
  name                = var.private_network_interface_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_ip_forwarding          = var.enable_ip_forwarding
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.ip_configuration_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    primary                       = var.ip_configuration_primary
    private_ip_address            = var.ip_configuration_private_ip_address
    private_ip_address_version    = var.ip_configuration_private_ip_address_version
    public_ip_address_id          = var.ip_configuration_public_ip_address_id
  }

  tags = {
    Function         = var.tag_function
    Application      = var.tag_application
    ApplicationOwner = var.tag_applicationowner
    Department       = var.tag_department
    Location         = var.tag_location
  }
}
