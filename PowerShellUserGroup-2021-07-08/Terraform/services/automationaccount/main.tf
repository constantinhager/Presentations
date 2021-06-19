module "ResourceGroup" {
  source = "../../global/ResourceGroup"

  resource_group_name = var.rg_name
  tag_creator         = "Constantin Hager"
  tag_function        = "Azure Automation DSC"
  location            = "West Europe"
}

module "AutomationAccount" {
  source = "../../global/AutomationAccount"

  automation_account_name = var.automation_account_name
  location                = "West Europe"
  resource_group_name     = module.ResourceGroup.resource_group_name
  tag_creator             = "Constantin Hager"
  tag_function            = "Automation Account"
}