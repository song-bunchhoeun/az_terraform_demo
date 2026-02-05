terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0" 
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstateuniqueaccountname"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
