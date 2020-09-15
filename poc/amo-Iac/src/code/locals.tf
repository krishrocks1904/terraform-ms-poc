locals {

  #use this local variable to set the location of azure resources
  location = lookup(var.locations, var.environment_name)

  #short
  loc = lookup(var.loc, var.environment_name)

  env = lookup(var.environment, var.environment_name)

  # use for prefix 'AVA-LER-EUW-DEV-01'
  prefix = "${var.companyName}-${var.service_name}-${local.loc}"

  rg_prefix = "${local.prefix}-${var.environment_name}-${var.environment_instance}"

  rg_prefix_withoutdash = "${var.companyName}${var.service_name}${local.loc}"
 
   # used to set common tags on most resources
  all_tags = {
    Department  = "${var.department_name}"
    Application = "${var.companyName}"
    Environment = "${local.env}"
  }

  tags = merge(local.all_tags, var.tags)

}


