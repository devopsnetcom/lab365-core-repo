
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

# Create custom role definition for parent role
module "parent_role" {
  source          = "./modules/role_definition"
  parentRole      = var.parentRole
  subscription_id = local.subscription_id
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



