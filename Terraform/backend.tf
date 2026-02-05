terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstate8998"
    container_name       = "tfstate6776"
    key                  = "prod.terraform.tfstate"
  }
}
