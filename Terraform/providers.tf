# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0" 
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-test-1"
  #   storage_account_name = "tfstateuniqueaccountname"
  #   container_name       = "tfstate"
  #   key                  = "prod.terraform.tfstate"
  # }
}


provider "azurerm" {
  features {}
  subscription_id = "b07e332b-f356-47ef-822e-92ff45891cc5"
  tenant_id = "7238cf22-2f07-4cf0-a57d-85fc41978373"
}

resource "random_string" "sa_suffix" {
  length  = 6
  upper   = false
  special = false
}
