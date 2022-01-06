locals {
  create_option = "Empty"
}

resource "azurerm_managed_disk" "md" {
  name                 = var.managed_disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = local.create_option
  disk_size_gb         = var.disk_size_gb

  tags = {
    Function         = var.tag_function
    Application      = var.tag_application
    ApplicationOwner = var.tag_applicationowner
    Department       = var.tag_department
    Location         = var.tag_location
  }
}
