

resource "azurerm_virtual_network" "TEST_vn" {
  depends_on = [
    azurerm_resource_group.TEST_resource_name
  ]
  for_each = {
    for sub in local.all_virtual_network : "${sub.rg_name}.${sub.vn_name}" => sub
    if sub.sub_name == "browarski-test"
  }

  name                = each.value.vn_name
  location            = var.location
  resource_group_name = each.value.rg_name
  address_space       = var.virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].addr
  dns_servers         = var.virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].dns_servers

  provider = azurerm.TEST
}


resource "azurerm_virtual_network_peering" "TEST_vn_peer" {
  depends_on = [
    azurerm_virtual_network.TEST_vn
  ]

  for_each = {
    for sub in local.all_peer : "${sub.rg_name}.${sub.vn_name}.${sub.peer_name}" => sub
    if sub.sub_name == "browarski-test"
  }

  name                = each.value.peer_name
  resource_group_name = each.value.rg_name

  virtual_network_name         = each.value.vn_name
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways

  # remote_virtual_network_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].peer[each.value.peer_name].peer_vn_id
  # remote_virtual_network_id = "/subscriptions/${each.value.peer_vn_sub}/resourceGroups/${each.value.peer_vn_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.peer_vn_name}"
  remote_virtual_network_id = "/subscriptions/${var.subscription_list[each.value.peer_vn_sub]}/resourceGroups/${each.value.peer_vn_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.peer_vn_name}"
  # remote_virtual_network_id = azurerm_virtual_network.TEST_vn["${each.value.peer_vn_rg}.${each.value.peer_vn_name}"].id
  provider = azurerm.TEST
}


resource "azurerm_subnet" "TEST_subnet" {
  depends_on = [
    azurerm_virtual_network.TEST_vn
  ]

  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub
    if sub.sub_name == "browarski-test"
  }

  virtual_network_name = each.value.vn_name
  name                 = each.value.subnet_name
  resource_group_name  = each.value.rg_name

  address_prefixes                  = var.virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].address_prefixes
  private_endpoint_network_policies = var.virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].private_endpoint_network_policies
  service_endpoints                 = var.virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].service_endpoints

  provider = azurerm.TEST
}

resource "azurerm_subnet_route_table_association" "TEST_sub_rt_assoc" {
  depends_on = [
    azurerm_subnet.TEST_subnet,
    azurerm_route_table.TEST_route_table
  ]
  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub
    if sub.sub_name == "browarski-test"
  }
  subnet_id = azurerm_subnet.TEST_subnet["${each.value.rg_name}.${each.value.vn_name}.${each.value.subnet_name}"].id

  route_table_id = azurerm_route_table.TEST_route_table["${each.value.rg_name}.${each.value.route_table_name}"].id
  # route_table_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].route_table_id

  provider = azurerm.TEST
}

resource "azurerm_subnet_network_security_group_association" "TEST_sub_nsg_assoc" {

  depends_on = [
    azurerm_subnet.TEST_subnet,
    azurerm_network_security_group.TEST_nsg
  ]
  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub
    if sub.sub_name == "browarski-test"
  }
  subnet_id = azurerm_subnet.TEST_subnet["${each.value.rg_name}.${each.value.vn_name}.${each.value.subnet_name}"].id


  # network_security_group_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].nsg_id
  network_security_group_id = azurerm_network_security_group.TEST_nsg["${each.value.rg_name}.${each.value.nsg_name}"].id

  provider = azurerm.TEST
}
