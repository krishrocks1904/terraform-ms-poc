# #########################################################################################
# #                  all the keyvault secrets to be added here in this file
# #########################################################################################
# #module "storage_account

# ########################## Add application insight as secret ####################
resource "azurerm_key_vault_secret" "app_insight" {

  name         = lower("${module.resource_group.name}-ins-key")
  key_vault_id = module.keyvault[0].azurerm_key_vault_id
  value        = module.applicationInsight[0].instrumentation_key
  tags         = local.tags
}

resource "azurerm_key_vault_secret" "sql_server_user_name" {

  name         = lower("${module.resource_group.name}-sql-server-user-name-key")
  key_vault_id = module.keyvault[0].azurerm_key_vault_id
  value        = module.az_mssql[0].sql_server_user_name
  tags         = local.tags
}
	
resource "azurerm_key_vault_secret" "sql_server_password" {

  name         = lower("${module.resource_group.name}-sql-server-user-pwd-key")
  key_vault_id = module.keyvault[0].azurerm_key_vault_id
  value        = module.az_mssql[0].sql_server_password
  tags         = local.tags
}


# ########################## Add storage account connection string as secret ####################
# resource "azurerm_key_vault_secret" "storages" {
#   count        = length(var.storage_accounts)
#   name         = lower("${module.resource_group.name}-${var.storage_accounts[count.index]}-primarykey")
#   key_vault_id = module.keyvault.azurerm_key_vault_id
#   value        = module.storage_account.primary_connection_string[count.index]
#   tags         = local.tags
# }
