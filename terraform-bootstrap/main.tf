provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-test-2"
  location = "Southeast Asia"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstateuniqueacct01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.tfstate]
}
