
# Terraform module to create an Azure Storage Account and a Storage Queue
resource "azurerm_storage_account" "sa" {
  name                      = var.storageAccount.name
  resource_group_name       = var.storageAccount.resource_group
  location                  = var.storageAccount.location

  access_tier               = var.storageAccount.access_tier
  account_kind              = var.storageAccount.kind
  account_replication_type  = var.storageAccount.account_replication_type
  account_tier              = var.storageAccount.account_tier
  min_tls_version           = var.storageAccount.tls_version

  is_hns_enabled                    = var.storageAccount.HNS_enabled
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = true
}

# Create a Storage Queue within the Storage Account
resource "azurerm_storage_queue" "queue" {
  name                 = var.storageAccount.queueservice.name
  storage_account_name = azurerm_storage_account.sa.name
}
