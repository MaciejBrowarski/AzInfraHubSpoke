
resource "azurerm_network_security_group" "PROD_nsg" {
  depends_on = [
    azurerm_resource_group.PROD_resource_name
  ]
  for_each = {
    for sub in local.all_nsg : "${sub.rg_name}.${sub.nsg_name}" => sub
    if sub.sub_name == "browarski-prod"
  }


  name                = each.value.nsg_name
  location            = var.location
  resource_group_name = each.value.rg_name

  # tags

  provider = azurerm.PROD

}


resource "azurerm_network_security_rule" "PROD_nsg_rule" {
  depends_on = [
    azurerm_network_security_group.PROD_nsg
  ]

  for_each = {
    for sub in local.all_security_rule : "${sub.rg_name}.${sub.nsg_name}.${sub.direction_name}.${sub.prio_nr}" => sub
    if sub.sub_name == "browarski-prod"
  }

  network_security_group_name = each.value.nsg_name
  direction                   = each.value.direction_name
  priority                    = each.value.prio_nr
  resource_group_name         = each.value.rg_name

  name                         = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].name
  access                       = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].access
  protocol                     = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].protocol
  source_port_range            = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_port_range
  source_port_ranges           = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_port_ranges
  destination_port_range       = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_port_range
  destination_port_ranges      = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_port_ranges
  source_address_prefix        = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_address_prefix
  source_address_prefixes      = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].source_address_prefixes
  destination_address_prefix   = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_address_prefix
  destination_address_prefixes = var.security_rule[each.value.sub_name][each.value.rg_name][each.value.nsg_name][each.value.direction_name][each.value.prio_nr].destination_address_prefixes

  provider = azurerm.PROD
}