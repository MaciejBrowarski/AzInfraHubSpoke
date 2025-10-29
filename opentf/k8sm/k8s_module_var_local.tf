
locals {
  all_akses = flatten([
    for sub_name, subscription in var.akses : [
      for rg_name, resource_group in subscription : [
        for aks_name, aks_detail in resource_group : {
          sub_name   = sub_name
          rg_name    = rg_name
          aks_name   = aks_name
          aks_detail = aks_detail
        }
      ]
    ]
  ])
}

variable "akses" {
  type = map(map(map(object({
    version                           = string
    default_node_pool_name            = string
    default_node_pool_node_count      = number
    default_node_pool_node_vm_size    = string
    dns_prefix_private_cluster        = string
    private_dns_zone_id               = string
    azure_policy_enabled              = bool
    identity_ids                      = list(string)
    default_node_pool_vnet_subnet_id  = string
    default_node_pool_node_max_pods   = number
    network_profile_plugin            = string
    network_profile_policy            = string
    network_service_cidr              = string
    network_pod_cidr                  = string
    network_profile_dns_service_ip    = string
    network_plugin_mode               = string
    admin_username                    = string
    linux_profile_key                 = string
    temporary_name_for_rotation       = string
    role_based_access_control_enabled = bool

    tags = object({
      Application = optional(string, "AKS")
      AdoRepo     = optional(string, "gitgub")
    })

  }))))

}


variable "aks_nodes" {
  type = map(map(map(map(object({
    name       = string
    node_count = number
    vm_size    = string
    vnet_subnet = object({
      id = string
    })
    # node_pool_max_pods = number

    # tags = object({
    #   Application = optional(string, "AKS")
    #   AdoRepo     = optional(string, "gitgub")
    # })

  })))))
}

locals {
  all_aks_nodes = flatten([
    for sub_name, subscription in var.aks_nodes : [
      for rg_name, resource_group in subscription : [
        for aks_name, aks_node_names in resource_group : [
          for aks_node_name, aks_node_detail in aks_node_names : {
            sub_name        = sub_name
            rg_name         = rg_name
            aks_name        = aks_name
            aks_node_name   = aks_node_name
            aks_node_detail = aks_node_detail
          }
        ]
      ]
  ]])
}
