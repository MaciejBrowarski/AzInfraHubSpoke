

resource "azurerm_private_dns_zone" "TEST_private_dns_zone" {

  for_each = {
    for sub in local.all_private_dns_zones : "${sub.rg_name}.${sub.zone_name}" => sub
    if sub.sub_name == "browarski-test"
  }


  name                = each.value.zone_name
  resource_group_name = each.value.rg_name
  tags                = var.private_dns_zone[each.value.sub_name][each.value.rg_name][each.value.zone_name].tags
  provider            = azurerm.TEST
}

resource "azurerm_private_dns_zone_virtual_network_link" "TEST_private_dns_zone_link" {
  depends_on = [

    azurerm_private_dns_zone.TEST_private_dns_zone
  ]

  for_each = {
    for sub in local.all_private_dns_zone_link : "${sub.rg_name}.${sub.zone_name}.${sub.zone_link_name}" => sub
    if sub.sub_name == "browarski-test"
  }

  name                  = each.value.zone_link_name
  resource_group_name   = each.value.rg_name
  private_dns_zone_name = each.value.zone_name
  # virtual_network_id    = azurerm_virtual_network.TEST_vn["${each.value.vnet_resource_group}.${each.value.vnet_name}"].id
  virtual_network_id   = "/subscriptions/${var.subscription_list[each.value.vn_sub]}/resourceGroups/${each.value.vn_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.vn_name}"
  registration_enabled = var.private_dns_zone_link[each.value.sub_name][each.value.rg_name][each.value.zone_name][each.value.zone_link_name].registration_enabled
  tags                 = var.private_dns_zone_link[each.value.sub_name][each.value.rg_name][each.value.zone_name][each.value.zone_link_name].tags
  provider             = azurerm.TEST
}