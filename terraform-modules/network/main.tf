
/* Create shared VNET */
resource "azurerm_virtual_network" "shared_vnet" {
  name                  = var.vnet_Name
  resource_group_name   = var.rg_Name
  location              = var.location
  address_space         = [var.vnet_AddressSpace]
}

# Create Subnets within the VNET
resource "azurerm_subnet" "guac_subnet" {
 for_each = {
    for subnet in var.subnet_NameList :
    subnet.name => subnet
  }

  name                 = each.value.name
  virtual_network_name = azurerm_virtual_network.shared_vnet.name
  resource_group_name  = var.rg_Name
  address_prefixes     = [each.value.addressPrefix]
}


# -------------------------------
# Network Security Group (NSG)
# -------------------------------
/*
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.vnet_Name}-nsg"
  location            = var.location
  resource_group_name = var.rg_Name

  security_rule {
    name                       = "Allow-Bastion-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.bastion_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Bastion-SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.bastion_subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-VNet-To-VNet"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Internet-Outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}*/
