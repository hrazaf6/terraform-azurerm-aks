output "subnet_id" {
  value = azurerm_virtual_network.this.subnet.*.id
}

output "subnet_names" {
  value = azurerm_virtual_network.this.subnet.*.name
}