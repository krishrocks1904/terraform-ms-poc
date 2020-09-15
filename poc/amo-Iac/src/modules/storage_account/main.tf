locals {
storage_account_properties = {
  account_replication_type= "LRS"
  account_tier = "Standard"
  account_kind = "StorageV2"

  access_tier = "Hot"
  enable_https_traffic_only  = true
  allow_blob_public_access  = false
  enable_manage_identity   = false
  min_tls_version  = "TLS1_0"
  containers = []
  tables = []
  queues = []

}
storage_account_configuration = merge(local.storage_account_properties,var.storage_account_configuration)
}

resource "azurerm_storage_account" "storage" {
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  name                      = lower(format("%s%s", replace(var.resource_group_name,"-",""), local.storage_account_configuration.sufix)) # var.storage_accounts[count.index]
  account_tier              = local.storage_account_configuration.account_tier             # "Standard"
  account_replication_type  = local.storage_account_configuration.account_replication_type #"GRS"

  access_tier  = local.storage_account_configuration.access_tier
  enable_https_traffic_only  = local.storage_account_configuration.enable_https_traffic_only 
  min_tls_version  = local.storage_account_configuration.min_tls_version  
  allow_blob_public_access  = local.storage_account_configuration.allow_blob_public_access 

  # network_rules {
  #   default_action             = "Deny"
  #   ip_rules                   = ["100.0.0.1"]
  #   virtual_network_subnet_ids = [azurerm_subnet.example.id]
  # }

  dynamic "identity" {
    for_each = local.storage_account_configuration.enable_manage_identity == true ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}

#########################################################################################################

resource "azurerm_storage_container" "containers" {
  for_each              = toset(local.storage_account_configuration.containers)
  name                  = each.value
  #resource_group_name   = var.resource_group_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

#########################################################################################################

#                     storage queue 
resource "azurerm_storage_queue" "storage_queue" {
  for_each              = toset(local.storage_account_configuration.queues)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage.name
}

#########################################################################################################

resource "azurerm_storage_table" "storage_table" {
 for_each              = toset(local.storage_account_configuration.tables)
  name                  = each.value
  storage_account_name = azurerm_storage_account.storage.name
}
#########################################################################################################


#########################################################################################################
#                     output variables 
#########################################################################################################
# primary_access_key - The primary access key for the storage account.
output "primary_access_key" {
  description = "primary key of the storage."
  value       = "${azurerm_storage_account.storage.*.primary_access_key}"
}
# secondary_access_key - The secondary access key for the storage account.
output "secondary_access_key" {
  description = "secondary_access_key of the storage."
  value       = "${azurerm_storage_account.storage.*.secondary_access_key}"
}
# primary_connection_string - The connection string associated with the primary location.
output "primary_connection_string" {
  description = "primary_connection_string of the storage."
  value       = "${azurerm_storage_account.storage.*.primary_connection_string}"
}
# secondary_connection_string - The connection string associated with the secondary location.
