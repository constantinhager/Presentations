resource "azurerm_availability_set" "av_set" {
  name                         = var.availability_set_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  managed                      = var.managed
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_domain_update_count

  tags = {
    Function         = var.tag_function
    Application      = var.tag_application
    ApplicationOwner = var.tag_applicationowner
    Department       = var.tag_department
    Location         = var.tag_location
  }
}
