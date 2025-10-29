

virtual_networks = {
  "browarski-prod" = {
    "core-network" = {
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
          "to_core_pe" = {
            # peer_vn_id                   = "/subscriptions/a1a3bafd-fb31-47e1-9ab3-af31afdbe854/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/azpclzprd1-vnet"
            peer_vn_sub                  = "PROD"
            peer_vn_rg                   = "core-network"
            peer_vn_name                 = "azpclzprd1-vnet"
            allow_virtual_network_access = true
            allow_forwarded_traffic      = false
            allow_gateway_transit        = false
            use_remote_gateways          = false
          }
          "to_spoke_aks" = {
            # peer_vn_id                   = "/subscriptions/a1a3bafd-fb31-47e1-9ab3-af31afdbe854/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/azpclzprd1-vnet"
            peer_vn_sub                  = "TEST"
            peer_vn_rg                   = "core-network"
            peer_vn_name                 = "azpclzaks1-vnet"
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
            peer_vn_sub  = "PROD"
            peer_vn_rg   = "core-network"
            peer_vn_name = "azpchubprd1-vnet"

            allow_virtual_network_access = true
            allow_forwarded_traffic      = true
            allow_gateway_transit        = false
            use_remote_gateways          = false

          }
        }
        subnet = {
          "azpclzprd1-pe-storage" = {

            route_table_name                  = "lzprd1-pe-udr"
            nsg_name                          = "lzprd1-pe-storage-nsg"
            address_prefixes                  = ["10.0.1.0/28"]
            service_endpoints                 = ["Microsoft.Storage"]
            private_endpoint_network_policies = "Enabled"
          }

        }
      }
    }
  }
  "browarski-test" = {
    "core-network" = {
      "azpclzaks1-vnet" = {
        addr        = ["10.128.0.0/22"]
        dns_servers = ["10.0.0.4"]

        peer = {
          "to_vnet_network-hub" = {
            # peer_vn_id = "/subscriptions/a1a3bafd-fb31-47e1-9ab3-af31afdbe854/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/azpchubprd1-vnet"
            peer_vn_sub  = "PROD"
            peer_vn_rg   = "core-network"
            peer_vn_name = "azpchubprd1-vnet"

            allow_virtual_network_access = true
            allow_forwarded_traffic      = true
            allow_gateway_transit        = false
            use_remote_gateways          = false

          }
        }
        subnet = {
          "azpclzaks1-pe-storage" = {

            route_table_name                  = "lzaks1-pe-storage-udr"
            nsg_name                          = "lzaks1-pe-storage-nsg"
            address_prefixes                  = ["10.128.0.0/28"]
            service_endpoints                 = ["Microsoft.Storage"]
            private_endpoint_network_policies = "Enabled"
          }
          "azpclzaks1-pe-kv" = {

            route_table_name                  = "lzaks1-pe-kv-udr"
            nsg_name                          = "lzaks1-pe-kv-nsg"
            address_prefixes                  = ["10.128.0.16/28"]
            service_endpoints                 = ["Microsoft.KeyVault"]
            private_endpoint_network_policies = "Enabled"
          }
          "azpclzaks1-pe-acr" = {

            route_table_name                  = "lzaks1-pe-acr-udr"
            nsg_name                          = "lzaks1-pe-acr-nsg"
            address_prefixes                  = ["10.128.0.32/28"]
            service_endpoints                 = ["Microsoft.ContainerRegistry"]
            private_endpoint_network_policies = "Enabled"
          }
          "azpclzaks1-nodes" = {

            route_table_name                  = "lzaks1-nodes-udr"
            nsg_name                          = "lzaks1-nodes-nsg"
            address_prefixes                  = ["10.128.2.0/23"]
            service_endpoints                 = null
            private_endpoint_network_policies = "Enabled"
          }
        }
      }
    }
  }
}


