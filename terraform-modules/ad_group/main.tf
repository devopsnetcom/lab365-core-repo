
locals {
  group_name = replace(
    replace(var.module.adGroup.nameTemplate, "{course}", var.course),
    "{module}", var.module.name
  )

  group_description = replace(
    replace(var.module.adGroup.description, "{course}", var.course),
    "{module}", var.module.name
  )
}

# Create an Azure AD Group with a name based on course and module
resource "azuread_group" "ad_group" {
  display_name     = local.group_name
  security_enabled = var.module.adGroup.type == "Security" ? true : false
  description      = local.group_description
}
