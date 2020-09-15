locals {
    subnet_properties ={ 
      "network_segment" ="10.2.0.0/16"
      "subnets"= ["default"]
      "third_octet"=5
  }

  subnet_configuration = merge(local.subnet_properties, var.virtual_network_configuration)
}

resource "azurerm_virtual_network" "network" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [local.subnet_configuration.network_segment]
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = length(local.subnet_configuration.subnets)
  name                 = local.subnet_configuration.subnets[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes       = [cidrsubnet(local.subnet_configuration.network_segment, local.subnet_configuration.third_octet, count.index)]

  service_endpoints         = ["Microsoft.Storage", "Microsoft.KeyVault","Microsoft.Web"]
}

output "network_id" {
  value = azurerm_virtual_network.network.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet.*.id
}



# resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
#   depends_on=[azurerm_virtual_network.network]

#   name                       = lower(format("%s-%s", azurerm_virtual_network.network.name, "diag"))
#   target_resource_id         = "${azurerm_virtual_network.network.id}"
#   log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.log_analytics.id}"
#   #storage_account_id = "${data.azurerm_storage_account.example.id}"

#   log {
#     category = "VMProtectionAlerts"
#     enabled  = false

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = false
#     }
#   }
# }
