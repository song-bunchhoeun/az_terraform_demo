# ============================================================================
# RESOURCE GROUP
# ============================================================================

output "resource_group_name" {
  description = "The name of the resource group (shared with DEV)"
  value       = data.azurerm_resource_group.existing.name
}

output "resource_group_location" {
  description = "The location of the resource group (shared with DEV)"
  value       = data.azurerm_resource_group.existing.location
}

# ============================================================================
# MANAGED IDENTITY
# ============================================================================

output "managed_identity_id" {
  description = "The ID of the managed identity"
  value       = module.identity.id
}

output "managed_identity_client_id" {
  description = "The client ID of the managed identity"
  value       = module.identity.client_id
}

output "managed_identity_principal_id" {
  description = "The principal ID of the managed identity"
  value       = module.identity.principal_id
}

# ============================================================================
# DATABASE
# ============================================================================

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = module.database.server_fqdn
}

output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = module.database.server_name
}

output "sql_database_names" {
  description = "The names of the SQL databases"
  value       = module.database.database_names
}

# ============================================================================
# REDIS CACHE
# ============================================================================

output "redis_hostname" {
  description = "The hostname of the Redis Cache"
  value       = module.cache.hostname
}

output "redis_primary_access_key" {
  description = "The primary access key for Redis Cache"
  value       = module.cache.primary_access_key
  sensitive   = true
}

# ============================================================================
# WEB APPS
# ============================================================================

output "api_dev_url" {
  description = "The URL of the API Dev web app"
  value       = "https://${module.compute.linux_web_app_hostnames["api_dev"]}"
}

output "portal_dev_url" {
  description = "The URL of the Portal Dev web app"
  value       = "https://${module.compute.windows_web_app_hostnames["portal_dev"]}"
}

output "function_app_url" {
  description = "The URL of the Function App"
  value       = "https://${module.compute.function_app_hostnames["main"]}"
}

output "static_web_app_url" {
  description = "The default URL of the Static Web App"
  value       = module.compute.static_web_app_hostnames["client_portal"]
}

# ============================================================================
# API MANAGEMENT
# ============================================================================

output "apim_gateway_url" {
  description = "The gateway URL of API Management"
  value       = azurerm_api_management.main.gateway_url
}

output "apim_portal_url" {
  description = "The developer portal URL of API Management"
  value       = azurerm_api_management.main.developer_portal_url
}

# ============================================================================
# AZURE FRONT DOOR
# ============================================================================

output "frontdoor_endpoint_api_hostname" {
  description = "The hostname of the Front Door API endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.api_dev.host_name
}

output "frontdoor_endpoint_portal_hostname" {
  description = "The hostname of the Front Door Portal endpoint"
  value       = azurerm_cdn_frontdoor_endpoint.portal_dev.host_name
}

output "frontdoor_id" {
  description = "The ID of the Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.main.resource_guid
}

# ============================================================================
# STORAGE
# ============================================================================

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.function.name
}
