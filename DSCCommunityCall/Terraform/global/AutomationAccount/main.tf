resource "azurerm_automation_account" "aa" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  tags = {
    creator  = var.tag_creator
    function = var.tag_function
  }
}
