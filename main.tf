# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-demo"
  location = "Southeast Asia"
}

# App Service Plan for Web App and Function App
resource "azurerm_service_plan" "asp" {
  name                = "asp-terraform-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Linux Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "webapp-terraform-demo-1234"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}

# Storage Account for Function App
resource "azurerm_storage_account" "sa" {
  name                     = "tfsa${random_string.sa_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Linux Function App
resource "azurerm_linux_function_app" "function" {
  name                = "func-terraform-demo-1234"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "8.0"
    }
  }
}
