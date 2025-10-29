
locals {
  all_akses = flatten([
    for rg_name, resource_group in var.akses : [
      for aks_name, aks_detail in resource_group : {
        rg_name    = rg_name
        aks_name   = aks_name
        aks_detail = aks_detail
      }
    ]
  ])
}

variable "akses" {
  type = map(map(object({
    version                          = string
    default_node_pool_name           = string
    default_node_pool_node_count     = number
    default_node_pool_node_vm_size   = string
    dns_prefix_private_cluster       = string
    private_dns_zone_id              = string
    azure_policy_enabled             = bool
    identity_ids                     = list(string)
    default_node_pool_vnet_subnet_id = string
    default_node_pool_node_max_pods  = number
    network_profile_plugin           = string
    network_profile_policy           = string
    network_service_cidr             = string
    network_pod_cidr                 = string
    network_profile_dns_service_ip   = string
    network_plugin_mode              = string
    admin_username                   = string
    linux_profile_key                = string

    tags = object({
      Application = optional(string, "AKS")
      AdoRepo     = optional(string, "gitgub")
    })

  })))

}
# data "azurerm_user_assigned_identity" "assigned_identity_MAIN" {
#   name                = "name_of_user_assigned_identity"
#resource_group_name = "name_of_resource_group"
# }

resource "azurerm_kubernetes_cluster" "aks_MAIN" {
  for_each = {
    for sub in local.all_akses : "${sub.rg_name}.${sub.aks_name}" => sub
  }

  name                              = each.value.aks_name
  location                          = var.location
  resource_group_name               = each.value.rg_name
  sku_tier                          = "Free"
  private_cluster_enabled           = true
  role_based_access_control_enabled = true
  local_account_disabled            = false
  dns_prefix_private_cluster        = each.value.aks_name
  private_dns_zone_id               = var.akses[each.value.rg_name][each.value.aks_name].private_dns_zone_id
  kubernetes_version                = var.akses[each.value.rg_name][each.value.aks_name].version
  azure_policy_enabled              = var.akses[each.value.rg_name][each.value.aks_name].azure_policy_enabled

  # private_dns_zone_id = ""
  identity {
    type         = "UserAssigned"
    identity_ids = var.akses[each.value.rg_name][each.value.aks_name].identity_ids

  }
  // ? azure_active_directory_role_based_access_control
  network_profile {
    network_plugin      = var.akses[each.value.rg_name][each.value.aks_name].network_profile_plugin
    network_policy      = var.akses[each.value.rg_name][each.value.aks_name].network_profile_policy
    service_cidr        = var.akses[each.value.rg_name][each.value.aks_name].network_service_cidr
    pod_cidr            = var.akses[each.value.rg_name][each.value.aks_name].network_pod_cidr
    dns_service_ip      = var.akses[each.value.rg_name][each.value.aks_name].network_profile_dns_service_ip
    network_plugin_mode = var.akses[each.value.rg_name][each.value.aks_name].network_plugin_mode
  }
  # disk_encryption_set_id = ""

  # private_dns_zone_id 
  linux_profile {
    admin_username = var.akses[each.value.rg_name][each.value.aks_name].admin_username
    ssh_key {
      key_data = var.akses[each.value.rg_name][each.value.aks_name].linux_profile_key

    }
  }

  default_node_pool {
    node_public_ip_enabled = false

    name           = var.akses[each.value.rg_name][each.value.aks_name].default_node_pool_name
    vnet_subnet_id = var.akses[each.value.rg_name][each.value.aks_name].default_node_pool_vnet_subnet_id
    node_count     = var.akses[each.value.rg_name][each.value.aks_name].default_node_pool_node_count
    vm_size        = var.akses[each.value.rg_name][each.value.aks_name].default_node_pool_node_vm_size
    max_pods = var.akses[each.value.rg_name][each.value.aks_name].default_node_pool_node_max_pods
    # host_encryption_enabled = true
  }
  tags = var.akses[each.value.rg_name][each.value.aks_name].tags

  provider = azurerm.MAIN

}




output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_MAIN["lz-aks.azpcaks-test"].kube_config_raw

  sensitive = true
}