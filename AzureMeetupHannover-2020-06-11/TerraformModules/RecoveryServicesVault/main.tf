resource "azurerm_recovery_services_vault" "rsv" {
  name                = var.recovery_services_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled

  tags = {
    creator  = var.tag_creator
    function = var.tag_function
  }
}
