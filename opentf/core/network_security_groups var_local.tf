
variable "security_rule" {
  type = map(map(map(map(map(object({

    name = string
    # priority                     = number
    access                       = string
    protocol                     = string
    source_port_range            = string
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    })
  )))))
}


variable "nsg" {
  type = map(map(map(object({
    tags = object({
      Change = string
    })
  }))))
}

locals {
  all_nsg = flatten([
    for sub_name, subscription in var.nsg : [
      for rg_name, resource_group in subscription : [
        for nsg_name, nsg in resource_group : {
          sub_name = sub_name
          rg_name  = rg_name
          nsg_name = nsg_name
        }
      ]
    ]
  ])

  all_security_rule = flatten([
    for sub_name, subscription in var.security_rule : [
      for rg_name, resource_group in subscription : [
        for nsg_name, direction in resource_group : [
          for direction_name, priority in direction : [
            for prio_nr, data in priority : {
              sub_name       = sub_name
              rg_name        = rg_name
              nsg_name       = nsg_name
              direction_name = direction_name
              prio_nr        = prio_nr
            }
          ]
        ]
      ]
    ]
  ])
}
