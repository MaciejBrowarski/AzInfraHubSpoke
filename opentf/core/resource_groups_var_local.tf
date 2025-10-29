
locals {
  # 
  # flatten variable for route table
  #
  all_resource_groups = flatten([
    for sub_name, subscription in var.resource_groups : [
      for res_name, resource_group in subscription : {
        sub_name = sub_name
        res_name = res_name
      }
    ]
  ])
}

variable "resource_groups" {
  type = map(map(object({
    #
    # maybe use it in the future
    location = optional(string, "westeurope")
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "RG")
      Change      = string
    })
  })))
}




