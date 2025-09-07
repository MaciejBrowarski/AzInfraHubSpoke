locals {

  all_virtual_network = flatten([

    for rg_name, vnet in var.virtual_networks : [
      for vn_name, vn_value in vnet : {
        rg_name = rg_name
        vn_name = vn_name
      }
    ]

  ])
  all_subnet = flatten([

    for rg_name, vnet in var.virtual_networks : [
      for vn_name, vn_detail in vnet : [
        for subnet_name, subnet_detail in vn_detail.subnet : {
          rg_name          = rg_name
          vn_name          = vn_name
          subnet_name      = subnet_name
          route_table_name = subnet_detail["route_table_name"]
          nsg_name         = subnet_detail["nsg_name"]
        }
      ]
      # ]
    ]
  ])

  all_peer = flatten([
    for rg_name, vnet in var.virtual_networks : [
      for vn_name, vn_detail in vnet : [
        for peer_name, peer_detail in vn_detail.peer : {
          rg_name   = rg_name
          peer_name = peer_name
          vn_name   = vn_name

          # peer_vn_susb = peer_detail["peer_vn_sub"]            
          peer_vn_rg                   = peer_detail["peer_vn_rg"]
          peer_vn_name                 = peer_detail["peer_vn_name"]
          allow_virtual_network_access = peer_detail["allow_virtual_network_access"]
          allow_forwarded_traffic      = peer_detail["allow_forwarded_traffic"]
          allow_gateway_transit        = peer_detail["allow_gateway_transit"]
          use_remote_gateways          = peer_detail["use_remote_gateways"]
        }
      ]
    ]
  ])
}

variable "virtual_networks" {
  type = map(map(object({
    addr = list(string)
    subnet = map(object({
      address_prefixes = list(string)

      # route_table_id = string
      route_table_name                  = string
      nsg_name                          = string
      service_endpoints                 = list(string)
      private_endpoint_network_policies = string
    }))

    peer = map(object({
      peer_vn_rg                   = string
      peer_vn_name                 = string
      allow_virtual_network_access = bool
      allow_forwarded_traffic      = bool
      allow_gateway_transit        = bool
      use_remote_gateways          = bool
    }))
  })))
}


resource "azurerm_virtual_network" "vn_MAIN" {
  depends_on = [
    azurerm_resource_group.resource_name_MAIN
  ]
  for_each = {
    for sub in local.all_virtual_network : "${sub.rg_name}.${sub.vn_name}" => sub

  }

  name                = each.value.vn_name
  location            = var.location
  resource_group_name = each.value.rg_name
  address_space       = var.virtual_networks[each.value.rg_name][each.value.vn_name].addr

  provider = azurerm.MAIN

}


resource "azurerm_virtual_network_peering" "vn_MAIN" {
  depends_on = [
    azurerm_virtual_network.vn_MAIN
  ]

  for_each = {
    for sub in local.all_peer : "${sub.rg_name}.${sub.vn_name}.${sub.peer_name}" => sub
  }

  name                = each.value.peer_name
  resource_group_name = each.value.rg_name

  virtual_network_name         = each.value.vn_name
  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways

  # remote_virtual_network_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].peer[each.value.peer_name].peer_vn_id
  # remote_virtual_network_id =  "/subscriptions/${sub}/resourceGroups/network/providers/Microsoft.Network/virtualNetworks/ebtt-we-vnet-tf-poc"  
  # remote_virtual_network_id = "/subscriptions/${each.value.peer_vn_sub}/resourceGroups/${each.value.peer_vn_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.peer_vn_name}"
  remote_virtual_network_id = azurerm_virtual_network.vn_MAIN["${each.value.peer_vn_rg}.${each.value.peer_vn_name}"].id
  provider                  = azurerm.MAIN
}


resource "azurerm_subnet" "subnet_MAIN" {
  depends_on = [
    azurerm_virtual_network.vn_MAIN
  ]

  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub
  }

  virtual_network_name = each.value.vn_name
  name                 = each.value.subnet_name
  resource_group_name  = each.value.rg_name

  address_prefixes                  = var.virtual_networks[each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].address_prefixes
  private_endpoint_network_policies = var.virtual_networks[each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].private_endpoint_network_policies
  service_endpoints                 = var.virtual_networks[each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].service_endpoints

  provider = azurerm.MAIN
}

resource "azurerm_subnet_route_table_association" "MAIN_sub_rt_assoc" {
  depends_on = [
    azurerm_subnet.subnet_MAIN,
    azurerm_route_table.route_table_MAIN
  ]
  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub
  }
  subnet_id = azurerm_subnet.subnet_MAIN["${each.value.rg_name}.${each.value.vn_name}.${each.value.subnet_name}"].id

  route_table_id = azurerm_route_table.route_table_MAIN["${each.value.rg_name}.${each.value.route_table_name}"].id
  # route_table_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].route_table_id

  provider = azurerm.MAIN
}

resource "azurerm_subnet_network_security_group_association" "MAIN_sub_nsg_assoc" {

  depends_on = [
    azurerm_subnet.subnet_MAIN,
    azurerm_network_security_group.nsg_MAIN
  ]
  for_each = {
    for sub in local.all_subnet : "${sub.rg_name}.${sub.vn_name}.${sub.subnet_name}" => sub

  }
  subnet_id = azurerm_subnet.subnet_MAIN["${each.value.rg_name}.${each.value.vn_name}.${each.value.subnet_name}"].id


  # network_security_group_id = var.sub_virtual_networks[each.value.sub_name][each.value.rg_name][each.value.vn_name].subnet[each.value.subnet_name].nsg_id
  network_security_group_id = azurerm_network_security_group.nsg_MAIN["${each.value.rg_name}.${each.value.nsg_name}"].id

  provider = azurerm.MAIN
}