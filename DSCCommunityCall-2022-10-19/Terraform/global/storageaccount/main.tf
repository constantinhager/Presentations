resource "azurerm_storage_account" "storeaccount" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  access_tier              = var.access_tier
  account_kind             = var.account_kind

  blob_properties {
    versioning_enabled = var.versioning_enabled
  }


  tags = {
    Function         = var.tag_function
    Application      = var.tag_application
    ApplicationOwner = var.tag_applicationowner
    Department       = var.tag_department
    Location         = var.tag_location
  }
}
