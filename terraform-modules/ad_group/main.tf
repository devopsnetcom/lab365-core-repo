
locals {
  group_name = replace(
    replace(var.ad_details.nameTemplate, "{course}", var.course_name),
    "{module}", var.module_name
  )

  group_description = replace(
    replace(var.ad_details.description, "{course}", var.course_name),
    "{module}", var.module_name
  )
}

# Create an Azure AD Group with a name based on course and module
resource "azuread_group" "ad_group" {
  display_name     = local.group_name
  security_enabled = var.ad_details.type == "Security" ? true : false
  description      = local.group_description
}
