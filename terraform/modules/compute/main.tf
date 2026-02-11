# ============================================================================
# Compute Module - App Services, Functions, Static Web Apps
# ============================================================================

# App Service Plans
resource "azurerm_service_plan" "this" {
  for_each = var.app_service_plans

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name
  tags                = var.tags
}

# Linux Web Apps
resource "azurerm_linux_web_app" "this" {
  for_each = var.linux_web_apps

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this[each.value.service_plan_key].id
  https_only          = true

  site_config {
    always_on         = each.value.always_on
    ftps_state        = "FtpsOnly"
    http2_enabled     = false
    minimum_tls_version = "1.2"
    
    application_stack {
      dotnet_version = each.value.dotnet_version
    }
  }

  app_settings = each.value.app_settings
  tags         = var.tags
}

# Windows Web Apps
resource "azurerm_windows_web_app" "this" {
  for_each = var.windows_web_apps

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this[each.value.service_plan_key].id
  https_only          = true

  site_config {
    always_on           = each.value.always_on
    ftps_state          = "FtpsOnly"
    http2_enabled       = false
    minimum_tls_version = "1.2"
    
    application_stack {
      current_stack  = "dotnet"
      dotnet_version = each.value.dotnet_version
    }
  }

  app_settings = each.value.app_settings
  tags         = var.tags
}

# Function Apps
resource "azurerm_windows_function_app" "this" {
  for_each = var.function_apps

  name                       = each.value.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.this[each.value.service_plan_key].id
  storage_account_name       = each.value.storage_account_name
  storage_account_access_key = each.value.storage_account_access_key
  https_only                 = true

  site_config {
    always_on           = false
    ftps_state          = "FtpsOnly"
    http2_enabled       = false
    minimum_tls_version = "1.2"
    
    application_stack {
      dotnet_version              = each.value.dotnet_version
      use_dotnet_isolated_runtime = true
    }

    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }

  app_settings = each.value.app_settings
  tags         = var.tags
}

# Static Web Apps
resource "azurerm_static_web_app" "this" {
  for_each = var.static_web_apps

  name                = each.value.name
  location            = each.value.location
  resource_group_name = var.resource_group_name
  sku_tier            = each.value.sku_tier
  sku_size            = each.value.sku_size
  tags                = var.tags
}
