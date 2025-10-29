

resource "azurerm_network_interface" "PROD_nic" {
  for_each = {
    for sub in local.all_internal_ips : "${sub.res_name}.${sub.internal_ip_name}" => sub
    if sub.sub_name == "browarski-prod"
  }

  name                = each.value.internal_ip_name
  location            = var.location
  resource_group_name = each.value.res_name

  accelerated_networking_enabled = var.internal_ips[each.value.sub_name][each.value.res_name][each.value.internal_ip_name].accelerated_networking_enabled
  ip_configuration {
    name      = "internal"
    subnet_id = "/subscriptions/${var.subscription_list[each.value.subnet_sub]}/resourceGroups/${each.value.subnet_rg}/providers/Microsoft.Network/virtualNetworks/${each.value.subnet_vn}/subnets/${each.value.subnet_name}"
    # subnet_id                     = azurerm_subnet.PROD_subnet["${var.internal_ips[each.value.res_name][each.value.internal_ip_name].subnet}"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PROD_public_ip["${var.internal_ips[each.value.sub_name][each.value.res_name][each.value.internal_ip_name].public}"].id
  }
  ip_forwarding_enabled = var.internal_ips[each.value.sub_name][each.value.res_name][each.value.internal_ip_name].ip_forwarding_enabled
  tags                  = var.internal_ips[each.value.sub_name][each.value.res_name][each.value.internal_ip_name].tags
  provider              = azurerm.PROD
}