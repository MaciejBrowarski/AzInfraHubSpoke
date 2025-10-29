

resource "azurerm_public_ip" "PROD_public_ip" {

  for_each = {
    for sub in local.all_public_ips : "${sub.res_name}.${sub.public_ip_name}" => sub
    if sub.sub_name == "browarski-prod"
  }

  name                = each.value.public_ip_name
  location            = var.location
  resource_group_name = each.value.res_name
  allocation_method   = var.public_ips[each.value.sub_name][each.value.res_name][each.value.public_ip_name].allocation_method


  tags     = var.public_ips[each.value.sub_name][each.value.res_name][each.value.public_ip_name].tags
  provider = azurerm.PROD
}