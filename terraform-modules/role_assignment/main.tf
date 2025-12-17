
locals {
  rg_scope = "/subscriptions/${var.subscription_id}/resourceGroups/${var.rg_name}"

  resolved_roles = {
    for ra in var.roleAssignments :
    replace(
      replace(ra.roleName, "{course}", var.course_name),
      "{module}", var.module_name
    ) => ra
  }
}

# Fetch Role Definitions
data "azurerm_role_definition" "role_defs" {
  for_each = local.resolved_roles

  name  = each.key
  scope = local.rg_scope
}

# Create Role Assignments
resource "azurerm_role_assignment" "role_assignments" {
  for_each = data.azurerm_role_definition.role_defs

  scope              = local.rg_scope
  role_definition_id = each.value.id
  principal_id       = var.principal_id
}