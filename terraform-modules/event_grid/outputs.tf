
output "event_grid_topic_id" {
  value = azurerm_eventgrid_topic.topic.id
}

output "event_grid_role_assignments" {
  value = azurerm_role_assignment.eventgrid_roles
}