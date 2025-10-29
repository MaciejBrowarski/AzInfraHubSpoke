
resource "azurerm_route_table" "PROD_route_table" {
  depends_on = [
    azurerm_resource_group.PROD_resource_name
  ]
  for_each = {
    for sub in local.all_route_tables : "${sub.res_name}.${sub.route_name}" => sub
    if sub.sub_name == "browarski-prod"
  }

  # it can be used when required
  # nowadays we only put RT in one location, but, maybe in the future it will be useful
  # 
  #  location                      = var.sub_route_tables[each.value.sub_name][each.value.res_name][each.value.route_name].location
  #
  location                      = var.location
  resource_group_name           = each.value.res_name
  name                          = each.value.route_name
  tags                          = var.route_tables[each.value.sub_name][each.value.res_name][each.value.route_name].tags
  bgp_route_propagation_enabled = var.route_tables[each.value.sub_name][each.value.res_name][each.value.route_name].enable_bgp
  #  lifecycle {
  #    ignore_changes = [  
  #      tags,
  #    ]
  #  }
  provider = azurerm.PROD
}

resource "azurerm_route" "PROD_route" {
  depends_on = [
    azurerm_route_table.PROD_route_table
  ]
  for_each = {
    for sub in local.all_routes : "${sub.res_name}.${sub.route_name}.${sub.net_name}" => sub
    if sub.sub_name == "browarski-prod"
  }

  resource_group_name    = each.value.res_name
  name                   = each.value.net_name
  route_table_name       = each.value.route_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address

  provider = azurerm.PROD

}
