output "module_role_name" {
  value = azurerm_role_definition.module[0].name
}

output "module_role_id" {
  value = azurerm_role_definition.module[0].id
}

output "module_role_definition_id" {
  value = azurerm_role_definition.module[0].role_definition_id
}