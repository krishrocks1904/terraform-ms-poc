 data "azurerm_client_config" "current" {}

# ############################# azure ad app registration  ############################
locals {
  keyvault_requires                         = length(var.keyvault) 
  application_insight_requires              = length(var.application_insight)
  log_analytics_requires                    = length(var.log_analytics) 
  az_mssql_requires                         = length(var.az_mssql) 
  app_service_requires                          = length(var.app_service)

  az_postgresql_requires                         = length(var.az_postgresql) 
  az_synapse_requires=length(var.az_synapse) 
}

# ############################# Create a keyvault  ############################

module "keyvault" {
  count  = local.keyvault_requires > 0 ? 1 :0
  source              = "../modules/keyvault"
  keyvault_configuration =var.keyvault

  name                = lower("${module.resource_group.name}-key")
  
  resource_group_name = module.resource_group.name
  location            = "${local.location}"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
  
  #if you require keyvault certifiate then set variable createSslCertificate as true and set the certificate related properties
  tags = "${local.tags}"
}



# ############################# Create a application insight  ############################
module "applicationInsight" {
  count  = local.application_insight_requires > 0 ? 1 :0
  source              = "../modules/app_insight"
  name                = lower("${module.resource_group.name}-ins")
  resource_group_name = module.resource_group.name
  location            = "${local.location}"
  tags                = "${local.tags}"
}
# ############################# Create log analytics  ####################################

module "log_analytics" {
  source                = "../modules/log_analytics"
  count                 = local.log_analytics_requires > 0 ? 1 :0
  name                  = lower("${module.resource_group.name}-log")
  resource_group_name   = module.resource_group.name
  location              = "${local.location}"
  tags                  = "${local.tags}"
  log_configuration     = var.log_analytics
}


# ############################# Create a app service  ###########################################
module "app_service" {
  count                     = local.app_service_requires > 0 ? 1 :0

  source                    = "../modules/app_service"
  resource_group_name       = module.resource_group.name
  location                  = local.location
  tags                      = local.tags
  app_service_configuration = var.app_service
  subnet_id                 = module.virtual_network[0].subnet_id[0]
}
# ############################# Create a virutal machines  ###########################################

# ############################# Create azure front-door  ###########################################

# ############################# Create azure sql DB  ###########################################

module "az_mssql" {
  count                 = local.az_mssql_requires > 0 ? 1 :0

  source              = "../modules/az_mssql"
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
  mssql_configuration = var.az_mssql
  
}
# ############################# Create azure postgreSql DB  ###########################################

module "az_postgresql" {
  count                 = local.az_postgresql_requires > 0 ? 1 :0

  source              = "../modules/az_postgresql"
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
  postgresql_configuration = var.az_postgresql
  
}

# ############################# Create azure synapse DB  ###########################################
module "az_synapse" {
  count                 = local.az_synapse_requires > 0 ? 1 :0

  source              = "../modules/az_synapse"
  resource_group_name = module.resource_group.name
  location            = local.location
  tags                = local.tags
  az_synapse_configuration = var.az_synapse
  
}