locals {
  all_virtual_network = flatten([
    for sub_name, subscription in var.virtual_networks : [
      for rg_name, vnet in subscription : [
        for vn_name, vn_value in vnet : {
          sub_name = sub_name
          rg_name  = rg_name
          vn_name  = vn_name
        }
      ]
    ]
  ])
  all_subnet = flatten([
    for sub_name, subscription in var.virtual_networks : [
      for rg_name, vnet in subscription : [
        for vn_name, vn_detail in vnet : [
          for subnet_name, subnet_detail in vn_detail.subnet : {
            sub_name         = sub_name
            rg_name          = rg_name
            vn_name          = vn_name
            subnet_name      = subnet_name
            route_table_name = subnet_detail["route_table_name"]
            nsg_name         = subnet_detail["nsg_name"]
          }
        ]
      ]
    ]
  ])

  all_peer = flatten([
    for sub_name, subscription in var.virtual_networks : [
      for rg_name, vnet in subscription : [
        for vn_name, vn_detail in vnet : [
          for peer_name, peer_detail in vn_detail.peer : {
            sub_name  = sub_name
            rg_name   = rg_name
            peer_name = peer_name
            vn_name   = vn_name

            peer_vn_sub                  = peer_detail["peer_vn_sub"]
            peer_vn_rg                   = peer_detail["peer_vn_rg"]
            peer_vn_name                 = peer_detail["peer_vn_name"]
            allow_virtual_network_access = peer_detail["allow_virtual_network_access"]
            allow_forwarded_traffic      = peer_detail["allow_forwarded_traffic"]
            allow_gateway_transit        = peer_detail["allow_gateway_transit"]
            use_remote_gateways          = peer_detail["use_remote_gateways"]
          }
        ]
      ]
    ]
  ])
}

variable "virtual_networks" {
  type = map(map(map(object({
    addr        = list(string)
    dns_servers = optional(list(string))
    subnet = map(object({
      address_prefixes = list(string)

      # route_table_id = string
      route_table_name                  = string
      nsg_name                          = string
      service_endpoints                 = list(string)
      private_endpoint_network_policies = string
    }))

    peer = map(object({
      peer_vn_sub                  = string
      peer_vn_rg                   = string
      peer_vn_name                 = string
      allow_virtual_network_access = bool
      allow_forwarded_traffic      = bool
      allow_gateway_transit        = bool
      use_remote_gateways          = bool
    }))
  }))))
}




