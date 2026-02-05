terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateuat9a"
    container_name       = "tfstateuat8as4"
    key                  = "prod.terraform.tfstate"
  }
}
