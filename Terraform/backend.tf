resource "azurerm_resource_group" "rg" {
  name     = "rg-test-1"
  location = "Southeast Asia"
}

resource "azurerm_storage_account" "state_sa" {
  name                     = "tfstateuat9a"
  resource_group_name      = azurerm_resource_group.state_rg.name
  location                 = azurerm_resource_group.state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state_container" {
  name                  = "tfstateuat8as4"
  storage_account_id    = azurerm_storage_account.state_sa.id
  container_access_type = "private"
}


terraform {
  backend "azurerm" {
    resource_group_name  = "rg-test-1"
    storage_account_name = "tfstateuat9a"
    container_name       = "tfstateuat8as4"
    key                  = "prod.terraform.tfstate"
  }
}
