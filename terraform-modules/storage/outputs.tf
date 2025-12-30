
output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.sa.name
}

output "storage_account_endpoint_url" {
  value = azurerm_storage_account.sa.id
}

output "storage_queue_name" {
  description = "The name of the Storage Queue"
  value       = azurerm_storage_queue.queue.name
}

output "storage_queue_endpoint_url" {
  value = azurerm_storage_queue.queue.url
}