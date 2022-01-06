resource "azurerm_resource_group" "resgroup" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    function = var.tag_function
    creator  = var.tag_creator
  }
}
