
locals {
  prefix = lower(var.user_name)
}

locals {
  mother_vnet_name = "${var.course_name}-${var.module_name}-vnet"
  bastion_name = "${var.course_name}-${var.module_name}-vnet-bastion"
}

# ✅ DATA source to reference existing RG
data "azurerm_resource_group" "rg" {
  name = var.rg_Name
}

data "azuread_service_principal" "github_spn" {
  client_id = var.github_spn_client_id
}

# Read specific Mother VNET
data "azurerm_virtual_network" "parent_vnet" {
  name                = local.mother_vnet_name
  resource_group_name = var.rg_Name  
}

# Read specific Bastion subnet
data "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = data.azurerm_virtual_network.parent_vnet.name
  resource_group_name  = var.rg_Name
}

# Get the Bastion Host
data "azurerm_bastion_host" "bastion_host" {
  name                = local.bastion_name
  resource_group_name = var.rg_Name
}


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



