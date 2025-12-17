
locals {
  subscription_display_name = var.subscriptionName
  courses_list              = var.courses
}

# Resolve subscription id from subscription display name
data "azurerm_subscriptions" "all" {}

locals {
  # Subscription ID resolved from display name
  subscription_id = [
    for sub in data.azurerm_subscriptions.all.subscriptions :
    sub.subscription_id if sub.display_name == local.subscription_display_name
  ][0]

  # flatten courses/modules into a map keyed by "course::module"
  course_module_list = flatten([
    for course in local.courses_list : [
      for mod in course.modules : {
        course_name = course.name
        module_name = mod.name
        module_obj  = mod
      }
    ]
  ])

  # course_module_map : map of course/module to module object
  course_module_map = {
    for item in local.course_module_list :
    "${item.course_name}::${item.module_name}" => item
  }
}

############################################
# Parent Role (Subscription Level)
############################################

module "parent_role" {
  source          = "../terraform-modules/role_definition/parent"

  subscription_id = local.subscription_id
  parentRole      = var.parentRole
}

############################################
# AD Groups (Per Course / Module)
############################################

module "ad_groups" {
  source   = "../terraform-modules/ad_group"
  for_each = local.course_module_map

  course_name      = each.value.course_name
  module_name      = each.value.module_name
  ad_details       = each.value.module_obj.adGroup
}

############################################
# Resource Groups (Per Course / Module)
############################################

module "resource_groups" {
  source   = "../terraform-modules/resource_group"
  for_each = local.course_module_map

  course_name      = each.value.course_name
  module_name      = each.value.module_name
  rg_details       = each.value.module_obj.resourceGroup
}


############################################
# Flatten module-level roles
############################################

locals {
  module_roles_list = flatten([
    for k, v in local.course_module_map : [
      for role in v.module_obj.roles : {
        key          = "${v.course_name}::${v.module_name}::${replace(role.nameTemplate, "{course}", v.course_name)}"
        course_name  = v.course_name
        module_name  = v.module_name
        role         = role
        rg_name      = module.resource_groups[k].rg_name
      }
    ]
  ])

  module_roles_map = {
    for r in local.module_roles_list :
    r.key => r
  }
}

################################################
# Module Role Definitions (Resource Group Level)
#################################################

module "module_roles" {
  source   = "../terraform-modules/role_definition/module"
  for_each = local.module_roles_map

  course_name     = each.value.course_name
  module_name     = each.value.module_name
  moduleRole      = each.value.role
  rg_name         = each.value.rg_name
  subscription_id = local.subscription_id

  depends_on = [
    module.resource_groups
  ]
}

############################################
# Role Assignments (RG Level)
############################################

module "role_assignments" {
  source   = "../terraform-modules/role_assignment"
  for_each = local.course_module_map

  course_name     = each.value.course_name
  module_name     = each.value.module_name
  rg_name         = module.resource_groups[each.key].rg_name
  subscription_id = local.subscription_id
  roleAssignments = each.value.module_obj.resourceGroup.roleAssignments
  principal_id    = module.ad_groups[each.key].group_object_id

  depends_on = [
    module.module_roles
  ]
}

/*
############# VNET & SUBNET & Basinton Subnet Deployment Code #############
module "vnet01" {
  source                  = "../terraform-modules/network"
  vnet_Name               = "${local.prefix}-vnet"
  user_name               = local.prefix
  rg_Name                 = data.azurerm_resource_group.rg.name
  location                = data.azurerm_resource_group.rg.location
  subnet_NameList         = var.subnet_NameList
  mother_vnet_name        = data.azurerm_virtual_network.parent_vnet.name
  mother_vnet_id          = data.azurerm_virtual_network.parent_vnet.id
  bastion_subnet_cidr     = data.azurerm_subnet.bastion.address_prefix
}

#### Azure Bastion Host Deployment ####
/*
module "bastionhost" {
  source                    = "../terraform-modules/bastion_host"
  bastion_pip_name          = "${local.prefix}-vnet-bastion-IPv4"
  bastion_Name              = "${local.prefix}-vnet-bastion"
  rg_Name                   = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  pip_allocation            = var.pip_allocation
  basiton_sku               = var.basiton_sku
  basinton_subnet_Id        = module.vnet01.basinton_subnet_Id
  basinton_ip_configuration = var.basinton_ip_configuration
  basiton_pip_sku           = var.basiton_pip_sku
}*/

/* Debug Outputs
output "principal_id_debug" {
  value = data.azuread_service_principal.github_spn.id
} */



