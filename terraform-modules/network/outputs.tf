output "vnet_Name" {
  value = azurerm_virtual_network.shared_vnet.name
}

output "vnet_Id" {
  value = azurerm_virtual_network.shared_vnet.id
}

output "subnet_Id" {
  value = azurerm_subnet.shared_subnet.*.id
}