terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateuat8a9b"
    container_name       = "tfstateuat6d9a"
    key                  = "erraform_azure.terraform.tfstate"
  }
}