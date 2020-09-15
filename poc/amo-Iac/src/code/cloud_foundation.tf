###############*********************** Cloud foundation started **********************##############
# this cloud foundation automation is in sequence
########################## ********* Providers *********######################################################

############################# Create a resource group ########################################

module "resource_group" {
  source              = "../modules/resource_group"
  resource_group_name = "${local.rg_prefix}"
  location            = "${local.location}"
  tags                = "${local.tags}"
}

############################# Create virtual network  ######################################

locals {
  virtual_network_requires  = length(var.virtual_network) #lookup(var.resources,"virtual_network", false)
}

module "virtual_network" {
  source              = "../modules/virtual_network"
  count = local.virtual_network_requires >0 ?1:0
  virtual_network_configuration = var.virtual_network
  
  vnet_name           = lower("${module.resource_group.name}-vnet")
  resource_group_name = "${local.rg_prefix}"
  location            = "${local.location}"
  tags                = "${local.tags}"
}
# ###############*********************** Cloud foundation completed **********************##############
