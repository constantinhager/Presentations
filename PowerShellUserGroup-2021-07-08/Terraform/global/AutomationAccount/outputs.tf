output "automation_account_id" {
  value = azurerm_automation_account.aa.id
}

output "automation_account_name" {
  value = azurerm_automation_account.aa.name
}

output "dsc_server_endpoint" {
  value = azurerm_automation_account.aa.dsc_server_endpoint
}

output "dsc_primary_access_key" {
  value = azurerm_automation_account.aa.dsc_primary_access_key
}

output "dsc_secondary_access_key" {
  value = azurerm_automation_account.aa.dsc_secondary_access_key
}
