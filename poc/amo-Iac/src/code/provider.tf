terraform {
   backend "azurerm" {}
 }

provider "azurerm" {
  # whilst the `xversion` attribute is optional, we recommend pinning to a given version of the Provider
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  client_id = var.client_id
  client_secret  = var.client_secret
   features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}