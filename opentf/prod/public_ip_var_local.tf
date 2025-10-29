# 
# flatten variable for public_ip
#
locals {
  all_public_ips = flatten([
    for sub_name, subscription in var.public_ips : [
      for res_name, resource_group in subscription : [
        for public_ip_name, rest in resource_group : {
          sub_name       = sub_name
          res_name       = res_name
          public_ip_name = public_ip_name
        }
      ]
  ]])
}

variable "public_ips" {
  # MAP
  # resource_group_name 
  # -> name
  type = map(map(map(object({
    #
    # maybe use it in the future
    allocation_method = optional(string, "static")
    location          = optional(string, "westeurope")
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "public_ip")
      Change      = string
    })
  }))))
}

