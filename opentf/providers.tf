provider "azurerm" {
  alias           = "MAIN"
  subscription_id = var.subscription_list["MAIN"]

  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

