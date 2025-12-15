
# Retrieve existing parent role definition if it exists
data "azurerm_role_definition" "existing_parent" {
  name  = var.parentRole.name
  scope = replace(var.parentRole.assignableScopes[0],"{subscriptionid}",var.subscription_id)
}

# Generate a UUID for the role definition if it does not already exist
resource "random_uuid" "parent_role_guid" {
    count = try(data.azurerm_role_definition.existing_parent.id, null) == null ? 1 : 0
}

# Create custom role definition for parent role
resource "azurerm_role_definition" "parent" {
    count = try(data.azurerm_role_definition.existing_parent.id, null) == null ? 1 : 0

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
    
}