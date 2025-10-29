
resource "azurerm_user_assigned_identity" "TEST_assigned_identity" {
  for_each = {
    for sub in local.all_managed_identites : "${sub.rg_name}.${sub.mi_name}" => sub
    if sub.sub_name == "browarski-test"
  }
  name                = each.value.mi_name
  resource_group_name = each.value.rg_name
  location            = var.location

  tags     = var.managed_identites[each.value.sub_name][each.value.rg_name][each.value.mi_name].tags
  provider = azurerm.TEST
}