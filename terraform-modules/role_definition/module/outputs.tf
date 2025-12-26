output "module_role_name" {
  value = local.module_role_exists ? data.azurerm_role_definition.module_existing.name : azurerm_role_definition.module[0].name
}

output "module_role_id" {
  value = local.module_role_exists ? data.azurerm_role_definition.module_existing.id : azurerm_role_definition.module[0].id
}

output "module_role_definition_id" {
  value = local.module_role_exists ? data.azurerm_role_definition.module_existing.id : azurerm_role_definition.module[0].role_definition_id
}