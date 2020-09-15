#name of keyvault
variable "name" {
  description = "[name] may only contain alphanumeric characters and dashes and must be between 3-24 chars"
}

variable "resource_group_name" {}
variable "location" {}
variable "tags" {}
variable "keyvault_configuration" {}

variable "tenant_id" {}
#object id for key
variable "object_id" {}



################################keyvault certificate variables###################################

variable "createSslCertificate" {
  default = false
}
variable "dns_names" {
  default = ["internal.contoso.com", "domain.hello.world"]
}
variable "subject" {
  default = "hello world"
}
variable "content_type" {
  default = "application/x-pkcs12"
}
variable "days_before_expiry" {
  default = 90
}
variable "action_type" {
  default = "AutoRenew"
}
###################################################################
