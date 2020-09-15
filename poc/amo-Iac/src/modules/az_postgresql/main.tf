 data "azurerm_client_config" "current" {}

########################################### sql default configurations ########################################################
locals {
 
  sql_properties = {
    version                 = "10.0" #expected version to be one of [9.5 9.6 11 10 10.0]
    enable_manage_identity  = false
      sku_name              = "GP_Gen5_4"
      storage_mb            = 640000
      backup_retention_days        = 7
      geo_redundant_backup_enabled = true

      auto_grow_enabled            = true

      public_network_access_enabled    = false
      ssl_enforcement_enabled          = true
      ssl_minimal_tls_version_enforced = "TLS1_2"

      enable_manage_identity = true
    databases               = []
    
  }
  postgresql_configuration = merge(local.sql_properties, var.postgresql_configuration)
}

########################################### sql default configurations ########################################################

resource "random_string" "random_storage_account_name" {
  length  = 24
  special = false
  upper   = false
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

resource "azurerm_postgresql_server" "postgresql_server" {
  name                         = lower( "${var.resource_group_name}-${local.postgresql_configuration.sqlserver_name}")
  location                     = var.location
  resource_group_name          = var.resource_group_name
  tags                         = var.tags

  version                      = local.postgresql_configuration.version
  administrator_login          = random_string.random_sql_user.result
  administrator_login_password = random_password.password.result

  sku_name   =local.postgresql_configuration.sku_name
  storage_mb = local.postgresql_configuration.storage_mb

  backup_retention_days        = local.postgresql_configuration.backup_retention_days
  geo_redundant_backup_enabled = local.postgresql_configuration.geo_redundant_backup_enabled
  auto_grow_enabled            = local.postgresql_configuration.auto_grow_enabled

  public_network_access_enabled    =  local.postgresql_configuration.public_network_access_enabled
  ssl_enforcement_enabled          = local.postgresql_configuration.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = local.postgresql_configuration.ssl_minimal_tls_version_enforced

  
  dynamic "identity" {
    for_each = local.postgresql_configuration.enable_manage_identity == true ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }
}


##################### ~~~~~~~~~~~~SQL Server Databases ~~~~~~~~~~~~~~~~~~~~~~~~~#####################

# resource "azurerm_postgresql_database" "example" {
#   name                = "exampledb"
#   resource_group_name = azurerm_resource_group.example.name
#   server_name         = azurerm_postgresql_server.example.name
#   charset             = "UTF8"
#   collation           = "English_United States.1252"
# }

#============================= output variables goes here ==================================
output "sql_server_user_name" {
  value = random_string.random_sql_user.result
}
output "sql_server_password" {
  value = random_password.password.result
}

#============================= output variables goes here ==================================

