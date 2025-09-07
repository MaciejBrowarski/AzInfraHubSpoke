


# SUB -> RG -> RT Name -> Entry
#  Allowed values are "VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance" and "None".
# 
route_tables = {
  "network" = {
    "hubprd1-rtr-udr" = {
      enable_bgp = false # it's inverted to: Propagate gateway routes in Portal
      tags = {
        Change = "CHG0001"
      }
    }
    "lzprd1-pe-udr" = {
      enable_bgp = false # it's inverted to: Propagate gateway routes in Portal
      tags = {
        Change = "CHG0001"
      }
    }
  }
}


#
#
#
routes = {
  "network" = {
    "hubprd1-rtr-udr" = {
      "rt-default" = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "Internet"
        next_hop_in_ip_address = null
      }
    }
    "lzprd1-pe-udr" = {
      "rt-default" = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.11.0.4"
      }
    }
  }
}
