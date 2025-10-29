#
# Resource Group
# -> name
variable "private_dns_zone" {
  type = map(map(map(object({
    tags = object({
      Change = string
    })
  }))))
}

#
# Resource Group
# -> dns name
variable "private_dns_zone_link" {
  type = map(map(map(map(object({
    # private_dns_zone_name = string
    vn_sub  = string
    vn_name = string
    vn_rg   = string

    registration_enabled = bool
    tags = object({
      Change = string
    })
  })))))
}

locals {
  all_private_dns_zones = flatten([
    for sub_name, subscription in var.private_dns_zone : [
      for rg_name, resource_group in subscription : [
        for zone_name, nsg in resource_group : {
          sub_name  = sub_name
          rg_name   = rg_name
          zone_name = zone_name
        }
      ]
    ]
  ])
  all_private_dns_zone_link = flatten([
    for sub_name, subscription in var.private_dns_zone_link : [
      for rg_name, resource_group in subscription : [
        for zone_name, zone_detail in resource_group : [
          for zone_link_name, zone_link_detail in zone_detail : {
            sub_name       = sub_name
            rg_name        = rg_name
            zone_name      = zone_name
            zone_link_name = zone_link_name
            vn_sub         = zone_link_detail.vn_sub
            vn_rg          = zone_link_detail.vn_rg
            vn_name        = zone_link_detail.vn_name
          }
        ]
      ]
    ]
  ])
}
