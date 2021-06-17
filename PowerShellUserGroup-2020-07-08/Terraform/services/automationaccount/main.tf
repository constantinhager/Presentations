module "ResourceGroup" {
  source = "../../Global/ResourceGroup"

  resource_group_name = "UserGroup-rg"
  tag_creator         = "Constantin Hager"
  tag_function        = "Azure Automation DSC"
  location            = "West Europe"
}

module "AutomationAccount" {
  source = "../../Global/AutomationAccount"

  automation_account_name = "chAutomationAcccountTest"
  location                = "West Europe"
  resource_group_name     = module.ResourceGroup.resource_group_name
  tag_creator             = "Constantin Hager"
  tag_function            = "Automation Account"
}

module "VariableDomainName" {
  source = "../../Global/AutomationAccountStringVariable"

  resource_group_name     = module.ResourceGroup.resource_group_name
  automation_account_name = module.AutomationAccount.automation_account_name
  description             = "The Domainname"

  string_variable_name = "DomainName"
  value                = "psug.local"
}

module "DomainAdminCredential" {
  source = "../../Global/AutomationCredential"

  automation_account_name = module.AutomationAccount.automation_account_name
  resource_group_name     = module.ResourceGroup.resource_group_name

  automation_credential_name = "DomainAdminCredential"
  username                   = "psug\\psuguser"
  password                   = "Pa$$w0rd!"
  description                = "The Domain Admin Password"
}

module "SafeModeCredential" {
  source = "../../Global/AutomationCredential"

  automation_account_name = module.AutomationAccount.automation_account_name
  resource_group_name     = module.ResourceGroup.resource_group_name

  automation_credential_name = "SafeModeCredential"
  username                   = "do_not_use"
  password                   = "S0mePassw0rd!"
  description                = "The Safemode Password"
}