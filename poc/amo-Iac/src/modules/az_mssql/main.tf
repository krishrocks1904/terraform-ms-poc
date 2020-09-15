 data "azurerm_client_config" "current" {}

########################################### sql default configurations ########################################################
locals {
 elasticpool_properties = {
      license_type = "LicenseIncluded"
      max_size_gb  = 756
      sku = {
        name     = "GP_Gen5"
        tier     = "GeneralPurpose"
        family   = "Gen5"
        capacity = 4
      }
      per_database_settings = {
        min_capacity = 0.25
        max_capacity = 4
      }
}

  mssql_properties = {
    version                 = "12.0" #value between 2.0 to 12.0
    enable_manage_identity  = false
    elasticpool_config      = {}
    databases               = []
    
    #if auditing requires then storage account needs to be created.
    requires_extended_auditing_policy= false
     mssql_storage = {
          account_tier = "Standard"
          account_replication_type= "LRS"
        }
    
  }
  mssql_configuration = merge(local.mssql_properties, var.mssql_configuration)
}

########################################### sql default configurations ########################################################

resource "random_string" "random_storage_account_name" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "mssql_sa" {
  count                    = local.mssql_configuration.requires_extended_auditing_policy == true ? 1 : 0
  name                     = random_string.random_storage_account_name.result
  account_tier             = local.mssql_configuration.mssql_storage.account_tier
  account_replication_type = local.mssql_configuration.mssql_storage.account_replication_type
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tags                     = var.tags
}

resource "random_string" "random_sql_user" {
  length      = 16
  special     = false
  number      = false
  min_numeric = 0
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_numeric      = 1
  min_upper        = 2
  min_special      = 1
}

resource "azurerm_sql_server" "sql_server" {
  name                         = lower( "${var.resource_group_name}-${local.mssql_configuration.sqlserver_name}")
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tags                         = var.tags
  version                      = local.mssql_configuration.version
  administrator_login          = random_string.random_sql_user.result
  administrator_login_password = random_password.password.result

  dynamic "extended_auditing_policy" {
    for_each = local.mssql_configuration.requires_extended_auditing_policy == true ? azurerm_storage_account.mssql_sa : []
    content {
      storage_endpoint                        = extended_auditing_policy.value.primary_blob_endpoint
      storage_account_access_key              = extended_auditing_policy.value.primary_access_key
      storage_account_access_key_is_secondary = true
      retention_in_days                       = 6
    }
  }

  dynamic "identity" {
    for_each = local.mssql_configuration.enable_manage_identity == true ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}

resource "azurerm_mssql_elasticpool" "elasticpool" {
  count               = length(local.mssql_configuration.elasticpool_config)
  name                = "${var.resource_group_name}-${merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).epl_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  server_name  = azurerm_sql_server.sql_server.name
  license_type = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).license_type
  max_size_gb  = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).max_size_gb

  sku {
    name     = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).sku.name
    tier     = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).sku.tier
    family   = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).sku.family
    capacity = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).sku.capacity
  }

  per_database_settings {
    min_capacity = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).per_database_settings.min_capacity
    max_capacity = merge(local.mssql_configuration.elasticpool_config,local.elasticpool_properties).per_database_settings.max_capacity
  }

  # threat_detection_policy {
  #         + disabled_alerts            = (known after apply)
  #         + email_account_admins       = (known after apply)
  #         + email_addresses            = (known after apply)
  #         + retention_days             = (known after apply)
  #         + state                      = (known after apply)
  #         + storage_account_access_key = (sensitive value)
  #         + storage_endpoint           = (known after apply)
  #         + use_server_default         = (known after apply)
  #       }
}

##################### ~~~~~~~~~~~~SQL Server Databases ~~~~~~~~~~~~~~~~~~~~~~~~~#####################
resource "azurerm_sql_database" "databases" {

  count               = length(local.mssql_configuration.databases)
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  server_name         = azurerm_sql_server.sql_server.name
  
  name                = local.mssql_configuration.databases[count.index]

  elastic_pool_name   = length(local.mssql_configuration.elasticpool_config)>0 ? azurerm_mssql_elasticpool.elasticpool[0].name : null

  dynamic "extended_auditing_policy" {
    for_each = local.mssql_configuration.requires_extended_auditing_policy == true ? azurerm_storage_account.mssql_sa : []
    content {
      storage_endpoint                        = extended_auditing_policy.value.primary_blob_endpoint
      storage_account_access_key              = extended_auditing_policy.value.primary_access_key
      storage_account_access_key_is_secondary = true
      retention_in_days                       = 6
    }
  }
}

# resource "azurerm_sql_firewall_rule" "sql_firewall" {
#   resource_group_name = var.resource_group_name
#   server_name = azurerm_sql_server.sql_server.name
  
#   count             = length(var.mssql_config.firewallConfig)
#   name                = var.mssql_config.firewallConfig[count.index].name
#   start_ip_address    = var.mssql_config.firewallConfig[count.index].start_ip_address
#   end_ip_address      = var.mssql_config.firewallConfig[count.index].end_ip_address
# }

resource "azurerm_sql_active_directory_administrator" "sql_ad_admin" {
  server_name         = azurerm_sql_server.sql_server.name
  resource_group_name = var.resource_group_name
  login               = "sqladmin"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}
#============================= output variables goes here ==================================
output "sql_server_user_name" {
  value = random_string.random_sql_user.result
}
output "sql_server_password" {
  value = random_password.password.result
}

#============================= output variables goes here ==================================

