output "app_service_plan_ids" {
  description = "Map of App Service Plan IDs"
  value       = { for k, v in azurerm_service_plan.this : k => v.id }
}

output "linux_web_app_ids" {
  description = "Map of Linux Web App IDs"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.id }
}

output "linux_web_app_hostnames" {
  description = "Map of Linux Web App default hostnames"
  value       = { for k, v in azurerm_linux_web_app.this : k => v.default_hostname }
}

output "windows_web_app_ids" {
  description = "Map of Windows Web App IDs"
  value       = { for k, v in azurerm_windows_web_app.this : k => v.id }
}

output "windows_web_app_hostnames" {
  description = "Map of Windows Web App default hostnames"
  value       = { for k, v in azurerm_windows_web_app.this : k => v.default_hostname }
}

output "function_app_ids" {
  description = "Map of Function App IDs"
  value       = { for k, v in azurerm_windows_function_app.this : k => v.id }
}

output "function_app_hostnames" {
  description = "Map of Function App default hostnames"
  value       = { for k, v in azurerm_windows_function_app.this : k => v.default_hostname }
}

output "static_web_app_ids" {
  description = "Map of Static Web App IDs"
  value       = { for k, v in azurerm_static_web_app.this : k => v.id }
}

output "static_web_app_hostnames" {
  description = "Map of Static Web App default hostnames"
  value       = { for k, v in azurerm_static_web_app.this : k => v.default_host_name }
}
