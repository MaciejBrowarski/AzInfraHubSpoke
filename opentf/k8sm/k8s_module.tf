module "aks_named_cluster" {
  source  = "Azure/aks/azurerm"
  version = "11.0.0"
  for_each = {
    for sub in local.all_akses : "${sub.rg_name}.${sub.aks_name}" => sub
    if sub.sub_name == "browarski-test"
  }
  log_analytics_workspace_enabled = false

  location            = var.location
  resource_group_name = each.value.rg_name


  cluster_name = each.value.aks_name
  # cluster_name = "test"

  # dns_prefix_private_cluster = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].dns_prefix_private_cluster
  private_cluster_enabled           = true
  prefix                            = each.value.aks_name
  identity_type                     = "UserAssigned"
  role_based_access_control_enabled = false
  identity_ids                      = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].identity_ids
  vnet_subnet = {
    id = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].default_node_pool_vnet_subnet_id
  }
  auto_scaling_enabled        = "false"
  temporary_name_for_rotation = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].temporary_name_for_rotation
  agents_size                 = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].default_node_pool_node_vm_size
  network_plugin              = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_profile_plugin
  net_profile_dns_service_ip  = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_profile_dns_service_ip

  network_plugin_mode = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_plugin_mode
  network_policy      = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_profile_policy

  net_profile_pod_cidr     = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_pod_cidr
  net_profile_service_cidr = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].network_service_cidr
  admin_username           = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].admin_username
  public_ssh_key           = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].linux_profile_key
  private_dns_zone_id      = var.akses[each.value.sub_name][each.value.rg_name][each.value.aks_name].private_dns_zone_id


  node_pools = var.aks_nodes[each.value.sub_name][each.value.rg_name][each.value.aks_name]

  providers = {
    azurerm = azurerm.TEST
  }

}





output "kube_config" {
  value = module.aks_named_cluster["lz-aks.akstest"].kube_config_raw

  sensitive = true
}