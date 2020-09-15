
########################################### sql default configurations ########################################################
locals {
 
  synapse_properties = {
    version                 = "12.0" #value between 2.0 to 12.0
    enable_manage_identity  = false
    databases               = []
    
    node_size_family     = "MemoryOptimized"
    node_size            = "Small"

    auto_scale = {
      max_node_count = 50
      min_node_count = 3
    }

   auto_pause = {
    delay_in_minutes = 15
   }
     synapse_storage = {
          account_tier = "Standard"
          account_replication_type= "LRS"
        }
    
  }
  az_synapse_configuration = merge(local.synapse_properties, var.az_synapse_configuration)
}

########################################### sql default configurations ########################################################

resource "random_string" "random_storage_account_name" {
  length  = 24
  special = false
  upper   = false
}

resource "azurerm_storage_account" "sql_sa" {
  name                     = random_string.random_storage_account_name.result
  account_tier             = local.az_synapse_configuration.synapse_storage.account_tier
  account_replication_type = local.az_synapse_configuration.synapse_storage.account_replication_type
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

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake_file_system" {
  name               = "${var.resource_group_name}-dlfs"
  storage_account_id = azurerm_storage_account.sql_sa.id
}

resource "azurerm_synapse_workspace" "workspace" {
  name                                  = replace("${var.resource_group_name}sws","-","") # name can contain only lowercase letters or numbers, and be between 1 and 45 characters long
  location                              = var.location
  resource_group_name                   = var.resource_group_name
  tags                                  = var.tags
  storage_data_lake_gen2_filesystem_id  = azurerm_storage_data_lake_gen2_filesystem.data_lake_file_system.id
  sql_administrator_login               = random_string.random_sql_user.result
  sql_administrator_login_password      = random_password.password.result
}

resource "azurerm_synapse_spark_pool" "spark_pool" {
  name                 = "spool01"  #name can contain only letters or numbers, must start with a letter, and be between 1 and 15 characters long
  synapse_workspace_id = azurerm_synapse_workspace.workspace.id
  tags                                  = var.tags
  node_size_family     = local.az_synapse_configuration.node_size_family
  node_size            = local.az_synapse_configuration.node_size

  auto_scale {
    max_node_count = local.az_synapse_configuration.auto_scale.max_node_count
    min_node_count =  local.az_synapse_configuration.auto_scale.min_node_count
  }

  auto_pause {
    delay_in_minutes = local.az_synapse_configuration.auto_pause.delay_in_minutes
  }
}
#============================= output variables goes here ==================================
output "sql_server_user_name" {
  value = random_string.random_sql_user.result
}
output "sql_server_password" {
  value = random_password.password.result
}

#============================= output variables goes here ==================================

