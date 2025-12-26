
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

# Generate a random UUID for the module role definition ID
resource "random_uuid" "module_role_guid" {}

# Create custom role definition for module role
resource "azurerm_role_definition" "module" {
   name               = replace(
                        replace(var.moduleRole.nameTemplate, "{course}", var.course_name),
                        "{module}", var.module_name
                      )
  role_definition_id = random_uuid.module_role_guid.result

  scope = local.resolved_scope

  description = var.moduleRole.description

  permissions {
    actions          = var.moduleRole.permissions.actions
    not_actions      = var.moduleRole.permissions.notActions
    data_actions     = var.moduleRole.permissions.dataActions
    not_data_actions = var.moduleRole.permissions.notDataActions
  }

}