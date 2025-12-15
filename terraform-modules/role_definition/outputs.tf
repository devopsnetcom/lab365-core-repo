output "parent_role_id" {
  value = try(
    data.azurerm_role_definition.existing_parent.id,
    azurerm_role_definition.parent[0].id
  )
}