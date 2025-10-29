
#
# 
resource_groups = {
  "browarski-prod" = {
    "core-backup" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
    "core-network" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
    "core-server" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
    "core-storage" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
  }
  "browarski-test" = {
    "core-network" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
    "lz-aks" = {
      location = "polandcentral"
      tags = {
        SPOC   = "Maciej Browarski"
        Change = "CHG001"
      }
    }
  }
}



