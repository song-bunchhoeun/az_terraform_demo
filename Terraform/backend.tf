
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-test-1"
    storage_account_name = "tfstateuat9a"
    container_name       = "tfstateuat8as4"
    key                  = "prod.terraform.tfstate"
  }
}
