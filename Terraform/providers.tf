# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0" 
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-test-1"
    storage_account_name = "tfstateuat9a"
    container_name       = "tfstateuat8as4"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}
