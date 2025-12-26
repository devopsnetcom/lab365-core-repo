
locals {
  resolved_scope = replace(
    replace(
      replace(
        var.moduleRole.assignableScopes[0],
        "{subscriptionid}",
        var.subscription_id
      ),
      "{course}",
      var.course_name
    ),
    "{module}",
    var.module_name
  )

  module_role_name = replace(
    replace(var.moduleRole.nameTemplate, "{course}", var.course_name),
    "{module}", var.module_name
  )

  # Deterministic UUID (stable across runs)
  module_role_definition_id = uuidv5(
    "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
    "${var.subscription_id}:${local.module_role_name}"
  )
}


# Create custom role definition for module role
resource "azurerm_role_definition" "module" {  
  name               = local.module_role_name
  role_definition_id = local.module_role_definition_id
  scope = local.resolved_scope
  description = var.moduleRole.description

  permissions {
    actions          = var.moduleRole.permissions.actions
    not_actions      = var.moduleRole.permissions.notActions
    data_actions     = var.moduleRole.permissions.dataActions
    not_data_actions = var.moduleRole.permissions.notDataActions
  }

}