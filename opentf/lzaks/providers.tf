terraform {
  # required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
  }
}
provider "azurerm" {
  alias           = "MAIN"
  subscription_id = var.subscription_list["MAIN"]

  features {
  }
}
