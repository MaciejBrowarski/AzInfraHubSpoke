
variable "security_rule" {
  type = map(map(map(map(object({

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
  ))))
}


variable "nsg" {
  type = map(map(object({
    tags = object({
      Change = string
    })
  })))
}

locals {
  all_nsg = flatten([
    for rg_name, resource_group in var.nsg : [
      for nsg_name, nsg in resource_group : {
        rg_name  = rg_name
        nsg_name = nsg_name
      }
    ]
  ])

  all_security_rule = flatten([
    for rg_name, resource_group in var.security_rule : [
      for nsg_name, direction in resource_group : [
        for direction_name, priority in direction : [
          for prio_nr, data in priority : {
            rg_name        = rg_name
            nsg_name       = nsg_name
            direction_name = direction_name
            prio_nr        = prio_nr
          }
        ]
      ]
    ]
  ])
}

resource "azurerm_network_security_group" "nsg_MAIN" {
  depends_on = [
    azurerm_resource_group.resource_name_MAIN
  ]
  for_each = {
    for sub in local.all_nsg : "${sub.rg_name}.${sub.nsg_name}" => sub
  }


  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = each.value.rg_name

  # tags

  provider = azurerm.MAIN

}


resource "azurerm_network_security_rule" "nsg_rule_MAIN" {
  depends_on = [
    azurerm_network_security_group.nsg_MAIN
  ]

  for_each = {
    for sub in local.all_security_rule : "${sub.rg_name}.${sub.nsg_name}.${sub.direction_name}.${sub.prio_nr}" => sub
  }

  network_security_group_name = each.value.nsg_name
  direction                   = each.value.direction_name
  priority                    = each.value.prio_nr
  resource_group_name         = each.value.rg_name

  name                         = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].name
  access                       = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].access
  protocol                     = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].protocol
  source_port_range            = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_port_range
  source_port_ranges           = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_port_ranges
  destination_port_range       = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_port_range
  destination_port_ranges      = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_port_ranges
  source_address_prefix        = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_address_prefix
  source_address_prefixes      = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_address_prefixes
  destination_address_prefix   = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_address_prefix
  destination_address_prefixes = var.security_rule[each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_address_prefixes

  provider = azurerm.MAIN
}