akses = {
  "browarski-test" = {
    "lz-aks" = {
      "akstest" = {
        default_node_pool_node_count      = 2
        default_node_pool_node_vm_size    = "Standard_D2as_v6"
        azure_policy_enabled              = true
        role_based_access_control_enabled = true
        version                           = "1.32.6"
        default_node_pool_name            = "system"
        default_node_pool_node_max_pods   = 30
        identity_ids                      = ["/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/lz-aks/providers/Microsoft.ManagedIdentity/userAssignedIdentities/lz-aks-mi"]
        # private_cluster_enabled = true
        default_node_pool_vnet_subnet_id = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/virtualNetworks/azpclzaks1-vnet/subnets/azpclzaks1-nodes"
        # message": "NetworkPolicy azure is not supported for network plugin kubenet",
        network_profile_plugin         = "azure"
        network_profile_policy         = "azure"
        network_plugin_mode            = "overlay"
        network_service_cidr           = "10.240.0.0/21"
        network_profile_dns_service_ip = "10.240.0.4"
        admin_username                 = "ansible"
        network_pod_cidr               = "10.248.0.0/21"
        linux_profile_key              = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVp1IrHrzPViUxJ+TN3ObkJzECnf3DnpnDEDI3NOyJGD1yHIn1j4AqYuVly9G+eUrv0v+BWsUGDHuZl8f3j/zfNMNftAsTqNiuhakgmODZS7qZw6BdznyLR9fYhlA8PzPo268D9eaqPj/oZxkW9ZrYc+Owgce3+vlopgjW/am4bOSlLUGQfnsr41rEllm11Ty76LLkgvL/KKEpgXiC7ZlCy6yB7VLdlbyaoCIEkIfs35/5cG4CcDdzrIzQfDOV2J4ZwLSdq9wZmoyOCFXhLxYnqvsgQs7NC/xAExJo7kfTGtIHr6JcO1Ewv3me4/zqgFV6E5aREnn2tbbIN17kmrAgC8F+E7WcZm9lJECgHzvS/RN7K0EV14HEoOj3EZY5q3YqxKhXjmJQF5cexAV+wJU/QZ6bckFkSw6TZvMQECKbtx5Fn6BIoRYV1yNNzERJfSQ2sbxHg1npv2xQrtdgkxHNS9VNPxRzfbg+U752JAFaGZHim88ZXhHvxQFJB2yGOU7T8Jgs2M3m4nnFuG5Z4C5Mor55KV9PMEKuCa3KP2RFqb8gbr1cgdpd+LlcucZtpHaMWOuwqU+xXZmG6HhuBrfJMK06fGuDGx/FTjymxQqfPrSZrVFdrcfosI88iekQokaeGlzY5qAI3J9TyT4eltc06oMY+DFhqGqCMjjaMwPyAw== maciej@smok"
        dns_prefix_private_cluster     = "lzaks1"
        temporary_name_for_rotation    = "tmpnodepool"
        private_dns_zone_id            = "/subscriptions/5f572be0-1526-4631-b744-e0e3c65055e2/resourceGroups/core-network/providers/Microsoft.Network/privateDnsZones/privatelink.polandcentral.azmk8s.io"
        tags = {
          Change = "CHG0001"
        }
      }
    }
  }
}

aks_nodes = {
  "browarski-test" = {
    "lz-aks" = {
      "akstest" = {
        "user" = {
          name       = "nodes"
          node_count = 1
          vm_size    = "Standard_D2as_v6"
          vnet_subnet = {
            id = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/virtualNetworks/azpclzaks1-vnet/subnets/azpclzaks1-nodes"
          }

        }
        "security" = {
          name       = "security"
          node_count = 1
          vm_size    = "Standard_D2as_v6"
          vnet_subnet = {
            id = "/subscriptions/11843af6-0af2-482c-8989-a67dcf7e22a9/resourceGroups/core-network/providers/Microsoft.Network/virtualNetworks/azpclzaks1-vnet/subnets/azpclzaks1-nodes"
          }

        }
      }
    }
  }
}