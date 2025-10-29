
nsg = {
  "browarski-prod" = {
    "core-network" = {
      "hubprd1-rtr-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
      "lzprd1-pe-storage-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
    }
  }
  "browarski-test" = {
    "core-network" = {
      "lzaks1-pe-storage-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
      "lzaks1-pe-kv-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
      "lzaks1-pe-acr-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
      "lzaks1-nodes-nsg" = {
        tags = {
          Change = "CHG0001"
        }
      }
    }
  }
}
#      
# Security rule must specify DestinationAddressPrefixes, DestinationAddressPrefix, or DestinationApplicationSecurityGroups
#
security_rule = {
  "browarski-prod" = {
    "core-network" = {
      "hubprd1-rtr-nsg" = {
        "Inbound" = {
          "200" = {
            name                       = "allow_ssh_in"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_ranges    = ["22", "63063", "80", "443", ]
            source_address_prefixes    = ["194.15.123.82/32"]
            destination_address_prefix = "10.0.0.0/28"
          }
          "210" = {
            name                       = "allow_ipsec_in"
            access                     = "Allow"
            protocol                   = "Udp"
            source_port_range          = "*"
            destination_port_ranges    = ["500", "4500"]
            source_address_prefix      = "194.15.123.82/32"
            destination_address_prefix = "10.0.0.0/28"
          }
          "220" = {
            name                       = "allow_lz_in"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_ranges    = ["443"]
            source_address_prefix      = "10.128.0.0/16"
            destination_address_prefix = "Internet"
          }
        }
      }


      "lzprd1-pe-storage-nsg" = {
        "Inbound" = {
          # priority                     = number
          "100" = {
            name                    = "allow_pe_sa"
            access                  = "Allow"
            protocol                = "Tcp"
            source_port_range       = "*"
            destination_port_range  = "443"
            source_address_prefixes = ["192.168.11.0/24"]
            # Security rule must specify DestinationAddressPrefixes, DestinationAddressPrefix, or DestinationApplicationSecurityGroups
            destination_address_prefix = "10.0.1.0/24"
          }

          "4096" = {
            name                       = "deny_all"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
        # "Outbound" = {
        #   "110" = {
        #     name = "allow_https_in"

        #     access            = "Allow"
        #     protocol          = "Tcp"
        #     source_port_range = "*"

        #     destination_port_ranges = ["80", "443"]

        #     source_address_prefix = "0.0.0.0"
        #     # Security rule must specify DestinationAddressPrefixes, DestinationAddressPrefix, or DestinationApplicationSecurityGroups
        #     destination_address_prefix = "10.10.0.0/28"
        #   }
        # }
      }
    }
  }
  "browarski-test" = {
    "core-network" = {
      "lzaks1-pe-storage-nsg" = {
        "Inbound" = {
          "4096" = {
            name                       = "deny_all"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
      "lzaks1-pe-kv-nsg" = {
        "Inbound" = {
          "4096" = {
            name                       = "deny_all"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
      "lzaks1-pe-acr-nsg" = {
        "Inbound" = {
          "4096" = {
            name                       = "deny_all"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
      "lzaks1-nodes-nsg" = {
        # "Inbound" = {
        #   "4096" = {
        #     name                       = "deny_all"
        #     access                     = "Deny"
        #     protocol                   = "*"
        #     source_port_range          = "*"
        #     destination_port_range     = "*"
        #     source_address_prefix      = "*"
        #     destination_address_prefix = "*"
        #   }
        # }
      }
    }
  }
}
