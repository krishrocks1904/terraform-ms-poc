 variable "subscription_id" {
   default ="cb72d91f-ab91-4d02-baca-a03f7cbb8726"
 }
variable "tenant_id" {
  default="637e705b-891d-4f55-9c52-a0d64092ff45"
}
variable "client_id" {
  default="f0df3c17-c5c5-48ac-ace0-e8c8c2776229"
}
 variable "client_secret" {
   default="V_skbOFPpD_VtNKL.m~jX48KJhG52-1T6q"
  description = "your azure service principal secret"
}


variable "companyName" {
        description= "name of organization"
}

# name of department for which this resource is provisioned, mostly this variable will be used in tags
variable "department_name" {
  description = "name of department for which this resource is provisioned, mostly this variable will be used in tags"
}

# this defines the name of the project
variable "service_name" {
  description = "this defines the name of the project"
}

variable "environment_name" {}
variable "environment_instance" {}

###########################************** redis cache ****************#################################
#sku_name
variable "firewallConfig" {
  default = [
    {
      rule_name = "front_end",
      start_ip  = "10.0.0.10",
      end_ip    = "10.0.0.10"
    }
  ]
}

###########################************** service bus ****************#################################

variable "servicebus_queues" {
  default = [
    {
      name                                 = "queue1"
      lock_duration                        = "PT1M" #Maximum value is 5 minutes. Defaults to 1 minute.
      requires_duplicate_detection         = false
      requires_session                     = true #default false Boolean flag which controls whether the Queue requires sessions. 
      dead_lettering_on_message_expiration = true
      max_delivery_count                   = 10 #Defaults to 10.
      enable_partitioning                  = true
    }
  ]
}
###########################**************  ****************#################################
