# ============================================================================
# EKYC Infrastructure - UAT Environment
# ============================================================================

locals {
  environment = "nonprod"
  env_short   = "uat"
  location    = var.location
  prefix      = var.prefix
  
  common_tags = merge(var.common_tags, {
    Environment = local.environment
    ManagedBy   = "Terraform"
  })
}

# ============================================================================
# RESOURCE GROUP (Use existing from DEV)
# ============================================================================

data "azurerm_resource_group" "existing" {
  name = "rg-${local.prefix}-${local.environment}-sea-002"
}

# Create a local to maintain compatibility with module references
locals {
  resource_group_name     = data.azurerm_resource_group.existing.name
  resource_group_location = data.azurerm_resource_group.existing.location
}

# ============================================================================
# MANAGED IDENTITY
# ============================================================================

module "identity" {
  source = "../../modules/identity"

  name                = "mi-github-${local.prefix}-${local.environment}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  
  federated_credentials = {
    "github-${local.prefix}-uat" = {
      audience = ["api://AzureADTokenExchange"]
      issuer   = "https://token.actions.githubusercontent.com"
      subject  = "repo:${var.github_repo}:environment:uat"
    }
  }
  
  tags = local.common_tags
}

# ============================================================================
# STORAGE
# ============================================================================

resource "random_string" "storage_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_storage_account" "function" {
  name                     = lower(replace("st${local.prefix}${local.env_short}${random_string.storage_suffix.result}", "-", ""))
  resource_group_name      = local.resource_group_name
  location                 = local.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "Storage"
  min_tls_version          = "TLS1_2"
  
  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = true
  default_to_oauth_authentication  = true
  https_traffic_only_enabled       = true

  tags = local.common_tags
}

# ============================================================================
# DATABASE
# ============================================================================

module "database" {
  source = "../../modules/database"

  server_name         = "sql-${local.prefix}-${local.env_short}-sea-002"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  server_version      = "12.0"
  admin_username      = var.sql_admin_username
  admin_password      = var.sql_admin_password
  minimum_tls_version = "1.2"
  public_network_access_enabled = true
  allow_azure_services = true
  
  databases = {
    operational = {
      name           = "eKYCOperational"
      collation      = "SQL_Latin1_General_CP1_CI_AS"
      max_size_gb    = 2
      sku_name       = "Basic"
      zone_redundant = false
    }
    transaction = {
      name           = "eKYCTransaction"
      collation      = "SQL_Latin1_General_CP1_CI_AS"
      max_size_gb    = 2
      sku_name       = "Basic"
      zone_redundant = false
    }
  }
  
  tags = local.common_tags
}

# ============================================================================
# REDIS CACHE
# ============================================================================

resource "random_string" "redis_suffix" {
  length  = 4
  upper   = false
  special = false
}

module "cache" {
  source = "../../modules/cache"

  name                = "redis-${local.prefix}-${local.environment}-sea-${random_string.redis_suffix.result}"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  sku_name            = "Balanced_B1"
  tags                = local.common_tags
}

# ============================================================================
# COMPUTE
# ============================================================================

resource "random_string" "asp_suffix" {
  length  = 4
  upper   = false
  special = false
}

module "compute" {
  source = "../../modules/compute"

  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  
  app_service_plans = {
    portal = {
      name     = "plan-${local.prefix}-${local.environment}-sea-002"
      os_type  = "Windows"
      sku_name = "B1"
    }
    api = {
      name     = "plan-${local.prefix}-${local.environment}-sea-002"
      os_type  = "Linux"
      sku_name = "B1"
    }
    function = {
      name     = "ASP-rg${local.prefix}${local.environment}sea001-${random_string.asp_suffix.result}"
      os_type  = "Windows"
      sku_name = "Y1"
    }
  }
  
  linux_web_apps = {
    api_dev = {
      name             = "app-${local.prefix}-api-${local.env_short}-sea-002"
      service_plan_key = "api"
      dotnet_version   = "8.0"
      always_on        = false
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "1"
      }
    }
  }
  
  windows_web_apps = {
    portal_dev = {
      name             = "app-${local.prefix}-portal-${local.env_short}-sea-002"
      service_plan_key = "portal"
      dotnet_version   = "v4.0"
      always_on        = false
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "1"
      }
    }
  }
  
  function_apps = {
    main = {
      name                       = "func-${local.prefix}-${local.env_short}-sea-002"
      service_plan_key           = "function"
      storage_account_name       = azurerm_storage_account.function.name
      storage_account_access_key = azurerm_storage_account.function.primary_access_key
      dotnet_version             = "v8.0"
      app_settings = {
        "FUNCTIONS_EXTENSION_VERSION" = "~4"
        "FUNCTIONS_WORKER_RUNTIME"    = "dotnet-isolated"
        "WEBSITE_RUN_FROM_PACKAGE"    = "1"
        "AzureWebJobsStorage"         = azurerm_storage_account.function.primary_connection_string
      }
    }
  }
  
  static_web_apps = {
    client_portal = {
      name     = "${local.prefix}-client-portal"
      location = "East Asia"
      sku_tier = "Free"
      sku_size = "Free"
    }
  }
  
  tags = local.common_tags
}

# ============================================================================
# API MANAGEMENT
# ============================================================================

resource "azurerm_api_management" "main" {
  name                = "apim-${local.prefix}-${local.environment}-sea-002"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = "Developer_1"

  tags = local.common_tags
}

resource "azurerm_api_management_api" "ekyc_dev" {
  name                = "ekyc-api-${local.env_short}"
  resource_group_name = local.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "EKYC API ${upper(local.env_short)}"
  path                = "ekyc-api-${local.env_short}"
  protocols           = ["https"]
  service_url         = "https://${module.compute.linux_web_app_hostnames["api_dev"]}"
  subscription_required = true
}

resource "azurerm_api_management_backend" "api_dev" {
  name                = "WebApp_app-${local.prefix}-api-${local.env_short}-sea-002"
  resource_group_name = local.resource_group_name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "https://${module.compute.linux_web_app_hostnames["api_dev"]}"
  description         = "app-${local.prefix}-api-${local.env_short}-sea-002"
  resource_id         = "https://management.azure.com${module.compute.linux_web_app_ids["api_dev"]}"
}

# ============================================================================
# AZURE FRONT DOOR (CDN)
# ============================================================================

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "afd-${local.prefix}-${local.environment}-global-001"
  resource_group_name = local.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  tags                = local.common_tags
}

resource "azurerm_cdn_frontdoor_endpoint" "api_dev" {
  name                     = "api-${local.env_short}-${local.prefix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  tags                     = local.common_tags
}

resource "azurerm_cdn_frontdoor_endpoint" "portal_dev" {
  name                     = "portal-${local.env_short}-${local.prefix}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  tags                     = local.common_tags
}

resource "azurerm_cdn_frontdoor_origin_group" "api_dev" {
  name                     = "og-${local.prefix}-api-${local.env_short}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "portal_dev" {
  name                     = "og-${local.prefix}-portal-${local.env_short}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "api_dev" {
  name                          = "origin-api-${local.env_short}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api_dev.id
  enabled                       = true
  host_name                     = module.compute.linux_web_app_hostnames["api_dev"]
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = module.compute.linux_web_app_hostnames["api_dev"]
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "portal_dev" {
  name                          = "origin-portal-${local.env_short}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_dev.id
  enabled                       = true
  host_name                     = module.compute.windows_web_app_hostnames["portal_dev"]
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = module.compute.windows_web_app_hostnames["portal_dev"]
  priority                      = 1
  weight                        = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "api_dev" {
  name                          = "route-api-${local.env_short}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.api_dev.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api_dev.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.api_dev.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "portal_dev" {
  name                          = "route-portal-${local.env_short}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.portal_dev.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.portal_dev.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.portal_dev.id]
  
  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}
