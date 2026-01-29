# Outputs for Web App and Function App names
output "web_app_name" {
  value = azurerm_linux_web_app.webapp.name
}

output "function_app_name" {
  value = azurerm_linux_function_app.function.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  value = [
    azurerm_subnet.subnet1.id,
    azurerm_subnet.subnet2.id,
    azurerm_subnet.subnet3.id
  ]
}
