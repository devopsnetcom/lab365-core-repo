output "parent_role_name" {
  value = azurerm_role_definition.parent.name
}

output "parent_role_id" {
  value = azurerm_role_definition.parent.id
}

output "parent_role_definition_id" {
  value = azurerm_role_definition.parent.role_definition_id
}
