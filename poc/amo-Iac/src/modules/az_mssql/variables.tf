#name of keyvault

variable "resource_group_name" {}
variable "location" {}
variable "tags" {}

# variable "mssqlserver_name" {}
# variable "sql_version" {
#   default = "12.0"
# }

# variable "enable_manage_identity" {}
variable "mssql_configuration" {}
# variable "requires_extended_auditing_policy" {}


# mssql_config = {
#     sqlserver_name                    = lower(format("%s-%s", local.rg_prefix, "sql"))
#     enable_manage_identity            = true
#     requires_extended_auditing_policy = false
#     requires_elasticpool              = false
#     version                           = "12.0" #value between 2.0 to 12.0
#     sku = {
#       name     = "GP_Gen5"        #GP_Gen4, BC_Gen5 , or the DTU based BasicPool, StandardPool, or PremiumPool
#       tier     = "GeneralPurpose" #GeneralPurpose, BusinessCritical, Basic, Standard, or Premium.
#       family   = "Gen5"           #Gen4 or Gen5.
#       capacity = 4
#     }
#     elasticpool_config = {
#       epl_name     = lower(format("%s-%s", local.rg_prefix, "epl"))
#       license_type = "LicenseIncluded"
#       max_size_gb  = 756

#       sku = {
#         name     = "GP_Gen5"
#         tier     = "GeneralPurpose"
#         family   = "Gen5"
#         capacity = 4
#       }
#       per_database_settings = {
#         min_capacity = 0.25
#         max_capacity = 4
#       }
#     }
#     databases = ["DB1","DB2"]
#     firewallConfig =[
#       # {
#       #   name = "backend-service"
#       #   start_ip_address    = "10.0.0.1"
#       #   end_ip_address      = "10.0.0.10"
#       # }
#       ]
#     }
