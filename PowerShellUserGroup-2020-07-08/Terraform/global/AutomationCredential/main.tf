resource "azurerm_automation_credential" "ac" {
  name                = var.automation_credential_name
  resource_group_name = var.resource_group_name

  username                = var.username
  password                = var.password
  description             = var.description
  automation_account_name = var.automation_account_name
}
