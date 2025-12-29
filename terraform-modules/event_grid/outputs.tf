
output "event_grid_topic_id" {
  value = data.azurerm_eventgrid_topic.existing_topic.id
}

output "event_grid_role_assignments" {
  value = azurerm_role_assignment.eventgrid_roles
}