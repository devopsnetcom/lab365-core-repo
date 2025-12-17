
locals {
  rg_name = replace(
    replace(var.rg_details.nameTemplate, "{course}", var.course_name),
    "{module}", var.module_name
  )
}

# Create an Azure Resource Group with a name based on course and module
resource "azurerm_resource_group" "rg_group" {
  name     = local.rg_name
  location = var.rg_details.location
}