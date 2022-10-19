output "windows_virtual_machine_id" {
  value = azurerm_windows_virtual_machine.windows_vm.id
}

output "windows_virtual_machine_private_ip" {
  value = azurerm_windows_virtual_machine.windows_vm.private_ip_address
}

output "windows_virtual_machine_public_ip" {
  value = azurerm_windows_virtual_machine.windows_vm.public_ip_address
}
