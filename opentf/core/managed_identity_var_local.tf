variable "managed_identites" {
  type = map(map(map(object({
    #
    # maybe use it in the future
    location = optional(string, "polandcentral")
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "RG")
      Change      = string
    })
  }))))
}

locals {
  # 
  # flatten variable for route table
  #
  all_managed_identites = flatten([
    for sub_name, subscription in var.managed_identites : [
    for rg_name, resource_group in subscription : [
      for mi_name, managed_identity in resource_group : {
        sub_name = sub_name
        rg_name = rg_name
        mi_name = mi_name
        # managed_identity = managed_identity
      }
    ]
    ]
  ])
}

