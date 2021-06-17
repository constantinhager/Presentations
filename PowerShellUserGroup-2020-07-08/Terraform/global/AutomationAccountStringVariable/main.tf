resource "azurerm_automation_variable_string" "aauvs" {
  name                    = var.string_variable_name
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  value                   = var.value
  encrypted               = var.encrypted
}
