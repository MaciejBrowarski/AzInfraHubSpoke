managed_identites = {
  "browarski-test" = {
  "lz-aks" = {
    "lz-aks-mi" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
  }
  }
}

/* managed_identites_assign = {
  "lz-aks" = {
    "lz-aks-mi" = {
    # VNET
        Scope = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/virtualNetworks/azpclzaks1-vnet"
        Role = "Network Contributor"
    }
    # DNS privatelink.polandcentral.azmk8s.io
        Scope = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/privateDnsZones/privatelink.polandcentral.azmk8s.io"
        Role = "Private DNS Zone Contributor"
  }
  #
  Scope = "subscriptions/browarski_tests"
  Role = "Contributor"
  */