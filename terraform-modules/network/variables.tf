variable "rg_Name" { type = string }
variable "location" { type = string }
variable "vnet_Name" { type = string }
variable "subnet_NameList" { 
  type = any
}
variable "vnet_AddressSpace" { type = string }
