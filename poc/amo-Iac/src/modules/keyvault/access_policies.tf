# resource "azurerm_key_vault_access_policy" "example" {
#   key_vault_id = azurerm_key_vault.example.id

#   tenant_id = "00000000-0000-0000-0000-000000000000"
#   object_id = "11111111-1111-1111-1111-111111111111"

#   key_permissions = [
#     "get",
#   ]

#   secret_permissions = [
#     "get",
#   ]
# }
