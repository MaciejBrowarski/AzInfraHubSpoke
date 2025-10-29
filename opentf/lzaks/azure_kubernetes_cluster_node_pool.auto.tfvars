aks_nodes = {
  "lz-aks" = {
    "azpcaks-test" = {
      "azpcaksnodes" = {
        node_pool_node_count     = 1
        node_pool_node_vm_size   = "Standard_D2as_v6"
        node_pool_max_pods = 40
        node_pool_vnet_subnet_id = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/virtualNetworks/azpclzaks1-vnet/subnets/azpclzaks1-nodes"
        tags = {
          Change = "CHG0001"
        }
      }
    }
  }
}