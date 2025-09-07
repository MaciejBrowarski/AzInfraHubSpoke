

virtual_networks = {
  "network" = {
    "azpchubprd1-vnet" = {
      addr = ["10.0.0.0/24"]
      subnet = {
        "azpchubprd1-rtr-sub" = {
          # route_table_enable = true
          # route_table_rg = "network"
          route_table_name                  = "hubprd1-rtr-udr"
          nsg_name                          = "hubprd1-rtr-nsg"
          address_prefixes                  = ["10.0.0.0/28"]
          service_endpoints                 = []
          private_endpoint_network_policies = "Disabled"
        }
      }
      peer = {
        "to_spoke_pe" = {
          # peer_vn_id                   = "/subscriptions/a1a3bafd-fb31-47e1-9ab3-af31afdbe854/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/azpclzprd1-vnet"
          peer_vn_rg                   = "network"
          peer_vn_name                 = "azpclzprd1-vnet"
          allow_virtual_network_access = true
          allow_forwarded_traffic      = false
          allow_gateway_transit        = false
          use_remote_gateways          = false

        }
      }

    }

    "azpclzprd1-vnet" = {
      addr = ["10.0.1.0/24"]

      peer = {
        "to_vnet_network-hub" = {
          # peer_vn_id = "/subscriptions/a1a3bafd-fb31-47e1-9ab3-af31afdbe854/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/azpchubprd1-vnet"

          peer_vn_rg   = "network"
          peer_vn_name = "azpchubprd1-vnet"

          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          allow_gateway_transit        = false
          use_remote_gateways          = false

        }
      }
      subnet = {
        "azpclzprd1-pe-storage" = {
          # route_table_enable = true
          route_table_name                  = "lzprd1-pe-udr"
          nsg_name                          = "lzprd1-pe-storage-nsg"
          address_prefixes                  = ["10.0.1.0/28"]
          service_endpoints                 = ["Microsoft.Storage"]
          private_endpoint_network_policies = "Enabled"
        }
        # "azpclzprd1-pe-backup" = {
        #   # route_table_enable = true
        #   route_table_name                  = "lzprd1-pe-udr"
        #   nsg_name                          = "lzprd1-pe-backup-nsg"
        #   address_prefixes                  = ["10.11.1.192/26"]
        #   service_endpoints                 =  ["Microsoft.Storage"]
        #   private_endpoint_network_policies = "Enabled"
        # }
      }
    }
  }

}





