
# Generate a random UUID for the parent role definition ID
resource "random_uuid" "parent_role_guid" {}

# Create custom role definition for parent role
resource "azurerm_role_definition" "parent" {
  name               = var.parentRole.name
  role_definition_id = random_uuid.parent_role_guid.result

  scope = replace(var.parentRole.assignableScopes[0],"{subscriptionid}",var.subscription_id)

  description = var.parentRole.description

  permissions {
    actions          = var.parentRole.permissions[0].actions
    not_actions      = var.parentRole.permissions[0].notActions
    data_actions     = var.parentRole.permissions[0].dataActions
    not_data_actions = var.parentRole.permissions[0].notDataActions
  }

  lifecycle {
    ignore_changes = [ role_definition_id ]
  }
}