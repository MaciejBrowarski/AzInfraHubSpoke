variable "route_tables" {
  type = map(map(object({
    enable_bgp = optional(bool, false)
    #
    # maybe use it in the future
    # location = optional(string, "westeurope")
    tags = object({
      Application = optional(string, "RouteTable")
      AdoRepo     = optional(string, "RouteTable")
    })
  })))
}

variable "routes" {
  type = map(map(map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))))
}

locals {
  # 
  # flatten variable for route table
  #
  all_route_tables = flatten([
    for res_name, resource_group in var.route_tables : [
      for route_name, route_table in resource_group : {
        res_name   = res_name
        route_name = route_name
      }
    ]
  ])

  #
  # flatten variable for route
  #

  all_routes = flatten([
    for res_name, resource_group in var.routes : [
      for route_name, route_table in resource_group : [
        for net_name, network in route_table : {
          res_name               = res_name
          route_name             = route_name
          net_name               = net_name
          address_prefix         = network.address_prefix
          next_hop_type          = network.next_hop_type
          next_hop_in_ip_address = network.next_hop_in_ip_address
        }
      ]
    ]
  ])
}
resource "azurerm_route_table" "route_table_MAIN" {
  depends_on = [
    azurerm_resource_group.resource_name_MAIN
  ]
  for_each = {
    for sub in local.all_route_tables : "${sub.res_name}.${sub.route_name}" => sub
  }

  # it can be used when required
  # nowadays we only put RT in one location, but, maybe in the future it will be useful
  # 
  #  location                      = var.sub_route_tables[each.value.sub_name][each.value.res_name][each.value.route_name].location
  #
  location                      = var.location
  resource_group_name           = each.value.res_name
  name                          = each.value.route_name
  tags                          = var.route_tables[each.value.res_name][each.value.route_name].tags
  bgp_route_propagation_enabled = var.route_tables[each.value.res_name][each.value.route_name].enable_bgp
  #  lifecycle {
  #    ignore_changes = [  
  #      tags,
  #    ]
  #  }
  provider = azurerm.MAIN
}

resource "azurerm_route" "route_MAIN" {
  depends_on = [
    azurerm_route_table.route_table_MAIN
  ]
  for_each = {
    for sub in local.all_routes : "${sub.res_name}.${sub.route_name}.${sub.net_name}" => sub

  }

  resource_group_name    = each.value.res_name
  name                   = each.value.net_name
  route_table_name       = each.value.route_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address

  provider = azurerm.MAIN

}
