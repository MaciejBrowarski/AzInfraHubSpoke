

resource "azurerm_resource_group" "TEST_resource_name" {

  # TODO:
  # if .. then var.location
  for_each = {
    for sub in local.all_resource_groups : "${sub.res_name}" => sub
    if sub.sub_name == "browarski-test"
  }

  location = var.resource_groups[each.value.sub_name][each.key].location
  name     = each.key
  tags     = var.resource_groups[each.value.sub_name][each.key].tags

  provider = azurerm.TEST
}


