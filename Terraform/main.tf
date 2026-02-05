# Resource Group
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

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-test-1"
  address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location   
    resource_group_name = azurerm_resource_group.rg.name
}

# # Subnet1
# resource "azurerm_subnet" "subnet1" {
#   name                 = "subnet1"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# # Subnet2
# resource "azurerm_subnet" "subnet2" {
#   name                 = "subnet2"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.2.0/24"]
# }

# # Subnet3
# resource "azurerm_subnet" "subnet3" {
#   name                 = "subnet3"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.3.0/24"]
# }

