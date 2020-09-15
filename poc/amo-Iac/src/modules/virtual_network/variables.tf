#name of keyvault
variable "vnet_name" {
  description = "[name] may only contain alphanumeric characters and dashes"
}
variable "resource_group_name" {}
variable "location" {}
variable "tags" {}

variable "virtual_network_configuration" {}
