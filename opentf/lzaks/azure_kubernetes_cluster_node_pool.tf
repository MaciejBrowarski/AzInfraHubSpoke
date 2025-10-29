

locals {
  all_aks_nodes = flatten([
    for rg_name, resource_group in var.aks_nodes : [
      for aks_name, aks_node_names in resource_group : [
        for aks_node_name, aks_node_detail in aks_node_names : {
          rg_name         = rg_name
          aks_name        = aks_name
          aks_node_name   = aks_node_name
          aks_node_detail = aks_node_detail
        }
      ]
    ]
  ])
}

variable "aks_nodes" {
  type = map(map(map(object({
    node_pool_node_count     = number
    node_pool_node_vm_size   = string
    node_pool_vnet_subnet_id = string
    node_pool_max_pods = number

    tags = object({
      Application = optional(string, "AKS")
      AdoRepo     = optional(string, "gitgub")
    })

  }))))

}

resource "azurerm_kubernetes_cluster_node_pool" "aks_nodes_MAIN" {
  for_each = {
    for sub in local.all_aks_nodes : "${sub.rg_name}.${sub.aks_name}.${sub.aks_node_name}" => sub
  }
  name = each.value.aks_node_name

  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks_MAIN["${each.value.rg_name}.${each.value.aks_name}"].id
  vm_size                = var.aks_nodes[each.value.rg_name][each.value.aks_name][each.value.aks_node_name].node_pool_node_vm_size
  node_count             = var.aks_nodes[each.value.rg_name][each.value.aks_name][each.value.aks_node_name].node_pool_node_count  
  node_public_ip_enabled = false
  vnet_subnet_id         = var.aks_nodes[each.value.rg_name][each.value.aks_name][each.value.aks_node_name].node_pool_vnet_subnet_id
  max_pods = var.aks_nodes[each.value.rg_name][each.value.aks_name][each.value.aks_node_name].node_pool_max_pods
  tags = var.aks_nodes[each.value.rg_name][each.value.aks_name][each.value.aks_node_name].tags

  provider = azurerm.MAIN
}