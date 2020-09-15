
# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = var.tags
}

output "name" {
  value = azurerm_resource_group.resource_group.name
}