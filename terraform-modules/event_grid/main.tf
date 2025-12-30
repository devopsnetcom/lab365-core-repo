
# create Event Grid Topic
resource "azurerm_eventgrid_topic" "topic" {
  name                = var.event_grid.name
  location            = var.event_grid.location
  resource_group_name = var.event_grid.resourceGroup

  public_network_access_enabled = true
  input_schema                  = var.event_grid.Schema
}

# 
# Role assignments for Event Grid
resource "azurerm_role_assignment" "eventgrid_roles" {
  for_each = {
    for r in var.event_grid.roles :
    r.name => r
  }

  role_definition_name = each.value.name
  scope                = replace(each.value.scope, "{topic_id}", azurerm_eventgrid_topic.topic.id)
  principal_id         = replace(each.value.principalId, "{principal_id}", lower(replace(replace(lower(var.principal_id), "/serviceprincipals/", ""),"/","")))
}


# create Event Subscriptions for the Event Grid Topic
resource "azurerm_eventgrid_event_subscription" "subscriptions" {
  for_each = {
    for es in var.event_grid.eventsubscriptions :
    es.name => es
  }

  name  = each.value.name
  scope = azurerm_eventgrid_topic.topic.id

  retry_policy {
    max_delivery_attempts = 30
    event_time_to_live    = 1440
  }

  dynamic "storage_queue_endpoint" {
    for_each = each.value.endpointType == "storagequeue" ? [1] : []
    content {
       queue_name = var.storage_queue_name
       storage_account_id = var.storage_account_id
    }
  }

  dynamic "webhook_endpoint" {
    for_each = each.value.endpointType == "webhook" ? [1] : []
    content {
      url = each.value.endpointUrl
    }
  }
}
