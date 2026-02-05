provider "azurerm" {
  features {}
    subscription_id = "b07e332b-f356-47ef-822e-92ff45891cc5"
    tenant_id = "7238cf22-2f07-4cf0-a57d-85fc41978373"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-test-1"
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
