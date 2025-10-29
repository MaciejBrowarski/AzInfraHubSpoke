
private_dns_zone = {
  "browarski-prod" = {
    "core-network" = {
      "privatelink.polandcentral.azmk8s.io" = {
        tags = {
          Change = "CHG0001"
        }
      }
      "az.browarski.net" = {
        tags = {
          Change = "CHG0001"
        }
      }
      # "privatelink.plc.backup.windowsazure.com" = {
      #   tags = {
      #     Change = "CHG0001"
      #   }
      # }
    }
  }
}

private_dns_zone_link = {
  "browarski-prod" = {
    "core-network" = {
      "privatelink.polandcentral.azmk8s.io" = {
        "privatelink.polandcentral.azmk8s.io-link" = {
          vn_sub               = "PROD"
          vn_rg                = "core-network"
          vn_name              = "azpchubprd1-vnet"
          registration_enabled = false
          tags = {
            Change = "CHG0001"
          }
        }
      }
      "az.browarski.net" = {
        "hub-link" = {
          vn_sub               = "PROD"
          vn_rg                = "core-network"
          vn_name              = "azpchubprd1-vnet"
          registration_enabled = false
          tags = {
            Change = "CHG0001"
          }
        }
        "aks-link" = {
          vn_sub               = "TEST"
          vn_rg                = "core-network"
          vn_name              = "azpclzaks1-vnet"
          registration_enabled = true
          tags = {
            Change = "CHG0001"
          }
        }
      }
    }
  }

}
