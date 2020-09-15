locals {
keyvault_properties = {
  sku_name = "standard"
}
keyvault_configuration = merge(local.keyvault_properties,var.keyvault_configuration)

}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = local.keyvault_configuration.sku_name

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

output "azurerm_key_vault_id" {
  description = "primary key of the storage."
  value       = azurerm_key_vault.keyvault.id
}
