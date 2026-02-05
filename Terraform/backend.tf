terraform {
    backend "azurerm" {
    resource_group_name  = "rg-test-1"
    storage_account_name = "tfstateuniqueaccountname"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
