output "vnet_name" {
  value = azurerm_virtual_network.virtual_network.name
}

output "vnet_resource_group_name" {
  value = azurerm_virtual_network.virtual_network.resource_group_name
}

output "vnet_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "vnet_addressspace" {
  value = azurerm_virtual_network.virtual_network.address_space
}
