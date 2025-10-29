# 
# flatten variable for vm_linuxs
#
locals {
  all_vm_linuxs = flatten([
    for sub_name, subscription in var.vm_linuxs : [
      for res_name, resource_group in subscription : [
        for vm_name, rest in resource_group : {
          sub_name = sub_name
          res_name = res_name
          vm_name  = vm_name
        }
      ]
    ]
  ])
}

variable "vm_linuxs" {
  # MAP
  # resource_group_name 
  # -> name
  type = map(map(map(object({
    admin_username             = string
    localtion                  = string
    encryption_at_host_enabled = bool
    size                       = string
    admin_ssh_key              = string
    os_disk_type               = string
    os_disk_size               = number
    image_publisher            = string
    image_offer                = string
    image_sku                  = string
    image_version              = string
    zone                       = number
    nic                        = string
    # sv_resource_group_name     = string
    # recovery_vault_name        = string
    # backup_policy_name         = string
    # exclude_disk_luns          = list(string)
    #
    # TODO: make it optional
    #
    # data_disk = string
    tags = object({
      Application = optional(string, "Infrastructure")
      AdoRepo     = optional(string, "managed_disk")
      Change      = string
    })
  }))))
}
