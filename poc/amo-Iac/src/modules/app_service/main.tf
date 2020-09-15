locals {
 app_service_plan_properties = {
      sku = {
          tier = "Standard"
          size = "S1"
        }
}
 app_service_properties = {   #if auditing requires then storage account needs to be created.
    requires_extended_auditing_policy= false
     storage = {
          account_tier = "Standard"
          account_replication_type= "LRS"
        }
}
  
  app_service_configuration = merge(local.app_service_properties, var.app_service_configuration)
}
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.resource_group_name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  sku {
    tier =  merge(local.app_service_configuration.app_service_plan,local.app_service_plan_properties).sku.tier
    size =  merge(local.app_service_configuration.app_service_plan,local.app_service_plan_properties).sku.size
  }
}

resource "azurerm_app_service" "app_service" {
  name                = "${var.resource_group_name}-app-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  app_service_plan_id = azurerm_app_service_plan.asp.id

  
  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"

    ip_restriction  {
      virtual_network_subnet_id = var.subnet_id
    }
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

 #virtual_network_subnet_id

  # connection_string {
  #   name  = "Database"
  #   type  = "SQLServer"
  #   value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  # }
}

# #######################################****************** END ***********************#########################################
