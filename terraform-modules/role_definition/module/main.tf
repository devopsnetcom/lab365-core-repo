
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
}

# Check if the role definition already exists
data "azurerm_role_definition" "module_existing" {
  name  = replace(
            replace(var.moduleRole.nameTemplate, "{course}", var.course_name),
            "{module}", var.module_name
          )
  scope = local.resolved_scope
}

# Determine if the module role already exists
locals {
  module_role_exists = can(data.azurerm_role_definition.module_existing.id)
}

# Generate a random UUID for the module role definition ID only if it does not already exist
resource "random_uuid" "module_role_guid" {
  count = local.module_role_exists ? 0 : 1
}

# Create custom role definition for module role
resource "azurerm_role_definition" "module" {
  count = local.module_role_exists ? 0 : 1
  
  name               = replace(
                        replace(var.moduleRole.nameTemplate, "{course}", var.course_name),
                        "{module}", var.module_name
                      )

  role_definition_id = random_uuid.module_role_guid[0].result

  scope = local.resolved_scope

  description = var.moduleRole.description

  permissions {
    actions          = var.moduleRole.permissions.actions
    not_actions      = var.moduleRole.permissions.notActions
    data_actions     = var.moduleRole.permissions.dataActions
    not_data_actions = var.moduleRole.permissions.notDataActions
  }

}