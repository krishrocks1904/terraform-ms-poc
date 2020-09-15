

################************** Make it parameterize **************#########################

resource "azurerm_network_security_rule" "inboud_AllowHttpHttps" {
  name                        = "AllowHttpHttps"
  priority                    = 3000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80-443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "AzureActiveDirectory"
    destination_port_ranges    = ["443", "80"]
    direction                  = "Outbound"
    name                       = "AllowAzureActiveDirectoryOutBound"
    priority                   = 100
    protocol                   = "TCP"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "VirtualNetwork"
    destination_port_ranges    = ["443", "80"]
    direction                  = "Inbound"
    name                       = "AllowClientCommunicationToApiInBound"
    priority                   = 100
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
  }

  security_rule {
    access                     = "Allow"
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "3443"
    direction                  = "Inbound"
    name                       = "AllowApiManagementInBound"
    priority                   = 110
    protocol                   = "TCP"
    source_address_prefix      = "ApiManagement"
    source_port_range          = "*"
  }
}
# resource "azurerm_subnet_network_security_group_association" "api_subnet_nsg_association" {
#   subnet_id                 = azurerm_subnet.apim_subnet.id
#   network_security_group_id = azurerm_network_security_group.apim-nsg.id
# }

# resource "azurerm_monitor_diagnostic_setting" "nsg_diagnostic_setting" {
#   depends_on=[azurerm_network_security_rule.inboud_AllowHttpHttps]

#   name                       = lower(format("%s-%s", azurerm_virtual_network.network.name, "nsg-diag"))
#   target_resource_id         = "${azurerm_network_security_group.nsg.id}"
#   log_analytics_workspace_id = "${data.azurerm_log_analytics_workspace.log_analytics.id}"
#   #storage_account_id = "${data.azurerm_storage_account.example.id}"

#   log {
#     category = "NetworkSecurityGroupEvent"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "NetworkSecurityGroupRuleCounter"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }

# }

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
