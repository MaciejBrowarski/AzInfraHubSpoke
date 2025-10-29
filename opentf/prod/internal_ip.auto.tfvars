internal_ips = {
  "browarski-prod" = {
    "core-network" = {
      "azpchubprd1-nic" = {
        subnet_sub                     = "PROD"
        subnet_rg                      = "core-network"
        subnet_vn                      = "azpchubprd1-vnet"
        subnet_name                    = "azpchubprd1-rtr-sub"
        private_ip_address_allocation  = "Dynamic"
        public                         = "core-network.azpchubprd1-pip"
        accelerated_networking_enabled = false
        ip_forwarding_enabled          = true

        tags = {
          SPOC   = "Maciej Browarski"
          Change = "CHG001"
        }
      }
    }
  }
}