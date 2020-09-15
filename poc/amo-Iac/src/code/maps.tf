
#MAPS for localtion
variable "locations" {
  type = map
  default = {
    dev     = "East US"
    tst     = "East US"
    ist     = "East US"
    uat     = "East US"
    pre     = "East US"
    pro     = "East US"
    default = "East US"
  }
}

# this map vairable is to use in name of the resources such as 'company-euw-dev-01'
variable "loc" {
  type = map

  default = {
    dev     = "eus"
    tst     = "eus"
    sit     = "eus"
    uat     = "eus"
    pre     = "eus"
    pro     = "eus"
    default = "eus"
  }
}


# this map vairable is to use in name of the resources tags 
variable "environment" {
  type = map

  default = {
    dev = "Development"
    tst = "Test"
    sit = "System Integration"
    uat = "User acceptance test"
    pre = "Pre production"
    pro = "production"

    default = "Development"
  }
}

