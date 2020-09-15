
locals {
log_properties = {
  sku = "PerGB2018"
  retention_in_days =30
}
log_configuration = merge(local.log_properties,var.log_configuration)

}

resource "azurerm_log_analytics_workspace"  "log_analytics" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku                 = local.log_configuration.sku #Free, PerNode, Premium, Standard, Standalone, Unlimited, and PerGB2018
  retention_in_days   = (local.log_configuration.sku == "Free" )? 7 : local.log_configuration.retention_in_days  #range between 30 and 730
}



