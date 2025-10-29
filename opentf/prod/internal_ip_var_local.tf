locals {
  # 
  # flatten variable for internal_ip
  #

  all_internal_ips = flatten([
    for sub_name, subscription in var.internal_ips : [
      for res_name, resource_group in subscription : [
        for internal_ip_name, rest in resource_group : {
          sub_name         = sub_name
          res_name         = res_name
          internal_ip_name = internal_ip_name
          subnet_sub       = rest.subnet_sub
          subnet_rg        = rest.subnet_rg
          subnet_vn        = rest.subnet_vn
          subnet_name      = rest.subnet_name

        }
      ]
    ]
  ])
}

variable "internal_ips" {
  # MAP
  # resource_group_name 
  # -> name
  type = map(map(map(object({
    #
    # maybe use it in the future
    allocation_method = optional(string, "dynamic")

    subnet_sub                     = string
    subnet_rg                      = string
    subnet_vn                      = string
    subnet_name                    = string
    accelerated_networking_enabled = bool
    # TODO: optional
    public                = string
    ip_forwarding_enabled = bool
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "public_ip")
      Change      = string
    })
  }))))
}

