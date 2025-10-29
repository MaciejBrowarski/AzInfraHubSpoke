
resource "azurerm_linux_virtual_machine" "PROD_vm_linux" {
  depends_on = [
    azurerm_network_interface.PROD_nic
  ]
  for_each = {
    for sub in local.all_vm_linuxs : "${sub.res_name}.${sub.vm_name}" => sub
    if sub.sub_name == "browarski-prod"
  }

  name                = each.value.vm_name
  location            = var.location
  resource_group_name = each.value.res_name
  size                = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].size
  admin_username      = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].admin_username
  zone                = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].zone


  encryption_at_host_enabled = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].encryption_at_host_enabled


  admin_ssh_key {
    username   = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].admin_username
    public_key = file(var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].admin_ssh_key)
  }

  network_interface_ids = [
    azurerm_network_interface.PROD_nic["${var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].nic}"].id
  ]

  boot_diagnostics {}

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].os_disk_type
    disk_size_gb         = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].os_disk_size

  }

  source_image_reference {
    publisher = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].image_publisher
    offer     = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].image_offer
    sku       = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].image_sku
    version   = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].image_version
  }
  tags     = var.vm_linuxs[each.value.sub_name][each.value.res_name][each.value.vm_name].tags
  provider = azurerm.PROD
}


# resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attach_PROD" {
#   for_each = {
#     for sub in local.all_vm_linuxs : "${sub.res_name}.${sub.vm_name}" => sub
#   }
#   managed_disk_id    = azurerm_managed_disk.managed_disk_PROD["${var.vm_linuxs[each.value.res_name][each.value.vm_name].data_disk}"].id
#   virtual_machine_id = azurerm_linux_virtual_machine.vm_linux_PROD["${each.value.res_name}.${each.value.vm_name}"].id
#   lun                = "10"
#   caching            = "None"

#   provider = azurerm.PROD
# }

# resource "azurerm_backup_protected_vm" "backup_protected_vm_PROD" {
#   for_each = {
#     for sub in local.all_vm_linuxs : "${sub.res_name}.${sub.vm_name}" => sub
#   }

#   resource_group_name = var.vm_linuxs[each.value.res_name][each.value.vm_name].sv_resource_group_name
#   recovery_vault_name = var.vm_linuxs[each.value.res_name][each.value.vm_name].recovery_vault_name
#   source_vm_id        = azurerm_linux_virtual_machine.vm_linux_PROD["${each.value.res_name}.${each.value.vm_name}"].id
#   backup_policy_id    = azurerm_backup_policy_vm.backup_policy_vm_PROD["${var.vm_linuxs[each.value.res_name][each.value.vm_name].sv_resource_group_name}.${var.vm_linuxs[each.value.res_name][each.value.vm_name].backup_policy_name}"].id
#   exclude_disk_luns   = var.vm_linuxs[each.value.res_name][each.value.vm_name].exclude_disk_luns

#   provider = azurerm.PROD
# }