
variable "resource_groups" {
  type = map(object({
    #
    # maybe use it in the future
    location = optional(string, "westeurope")
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "RG")
      Change      = string
    })
  }))
}

resource "azurerm_resource_group" "resource_name_MAIN" {
  for_each = var.resource_groups
  # TODO:
  # if .. then var.location
  location = var.resource_groups[each.key].location
  name     = each.key
  tags     = var.resource_groups[each.key].tags

  provider = azurerm.MAIN
}


