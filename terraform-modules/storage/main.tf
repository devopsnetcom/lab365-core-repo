
# Terraform module to create an Azure Storage Account and a Storage Queue
resource "azurerm_storage_account" "sa" {
  name                      = var.storage_account.name
  resource_group_name       = var.storage_account.resource_group
  location                  = var.storage_account.location

  access_tier               = var.storage_account.access_tier
  account_kind              = var.storage_account.kind
  account_replication_type  = var.storage_account.account_replication_type
  account_tier              = var.storage_account.account_tier
  min_tls_version          = var.storage_account.tls_version

  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true
}

# Create a Storage Queue within the Storage Account
resource "azurerm_storage_queue" "queue" {
  name                 = var.storage_account.queueservice.name
  storage_account_name = azurerm_storage_account.sa.name
}
