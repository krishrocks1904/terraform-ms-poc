resource "azurerm_application_insights" "app_insight" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags
}

output "instrumentation_key" {
  value = azurerm_application_insights.app_insight.instrumentation_key
}


output "app_id" {
  value = azurerm_application_insights.app_insight.app_id
}
