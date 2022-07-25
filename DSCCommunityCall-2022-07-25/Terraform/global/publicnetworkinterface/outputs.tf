output "private_network_interface_id" {
  value = azurerm_network_interface.ni.id
}

output "private_ip_address" {
  value = azurerm_network_interface.ni.private_ip_address
}

output "virtual_machine_id" {
  value = azurerm_network_interface.ni.virtual_machine_id
}
