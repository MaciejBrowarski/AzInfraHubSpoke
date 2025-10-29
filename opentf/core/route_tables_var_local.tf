variable "route_tables" {
  type = map(map(map(object({
    enable_bgp = optional(bool, false)
    #
    # maybe use it in the future
    # location = optional(string, "westeurope")
    tags = object({
      Application = optional(string, "RouteTable")
      AdoRepo     = optional(string, "RouteTable")
    })
  }))))
}

variable "routes" {
  type = map(map(map(map(object({
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  })))))
}

locals {
  # 
  # flatten variable for route table
  #
  all_route_tables = flatten([
    for sub_name, subscription in var.route_tables : [
      for res_name, resource_group in subscription : [
        for route_name, route_table in resource_group : {
          sub_name   = sub_name
          res_name   = res_name
          route_name = route_name
        }
      ]
    ]
  ])

  #
  # flatten variable for route
  #

  all_routes = flatten([
    for sub_name, subscription in var.routes : [
      for res_name, resource_group in subscription : [
        for route_name, route_table in resource_group : [
          for net_name, network in route_table : {
            sub_name               = sub_name
            res_name               = res_name
            route_name             = route_name
            net_name               = net_name
            address_prefix         = network.address_prefix
            next_hop_type          = network.next_hop_type
            next_hop_in_ip_address = network.next_hop_in_ip_address
          }
        ]
      ]
    ]
  ])
}
