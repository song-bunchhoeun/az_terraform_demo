# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0" 
    }
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
