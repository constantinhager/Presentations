module "ResourceGroup" {
  source = "../../../global/ResourceGroup"

  resource_group_name = var.rg_name
  tag_creator         = "Constantin Hager"
  tag_function        = "Azure Automation DSC"
  location            = "West Europe"
}

module "storageaccount" {
  source                   = "../../../global/storageaccount"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  account_tier             = "Standard"
  resource_group_name      = module.ResourceGroup.resource_group_name
  storage_account_name     = var.storage_account_name
  location                 = "West Europe"

  tag_function         = "DSC Storage Account"
  tag_application      = "DSC Diagnotics Storage"
  tag_applicationowner = "COC AG"
  tag_department       = "IT"
  tag_location         = "West Europe"
}

module "storagecontainer" {
  source                   = "../../../global/storagecontainer"
  storage_container_name = "dsc"
  storage_account_name = module.storageaccount.storage_account_name
}
