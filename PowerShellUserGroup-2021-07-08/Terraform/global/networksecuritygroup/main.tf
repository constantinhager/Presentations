resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Function         = var.tag_function
    Application      = var.tag_application
    ApplicationOwner = var.tag_applicationowner
    Department       = var.tag_department
    Location         = var.tag_location
  }
}
