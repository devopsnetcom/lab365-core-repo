# Existing Event Grid Topic
data "azurerm_eventgrid_topic" "existing_topic" {
  name                = var.event_grid.name
  resource_group_name = var.event_grid.resourceGroup
}

# Role assignments for Event Grid
resource "azurerm_role_assignment" "eventgrid_roles" {
  for_each = {
    for r in var.event_grid.roles :
    r.name => r
  }

  role_definition_name = each.value.name
  scope                = replace(each.value.scope, "{topic_id}", data.azurerm_eventgrid_topic.existing_topic.id)
  principal_id         = replace(each.value.principalId, "{principal_id}", lower(replace(replace(lower(var.principal_id), "/serviceprincipals/", ""),"/","")))
}