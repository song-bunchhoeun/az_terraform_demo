# Outputs for Web App and Function App names
output "web_app_name" {
  value = azurerm_linux_web_app.webapp.name
}

output "function_app_name" {
  value = azurerm_linux_function_app.function.name
}
