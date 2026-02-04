output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

# output "subnet_ids" {
#   value = {
#     subnet1 = azurerm_subnet.subnet1.id
#     subnet2 = azurerm_subnet.subnet2.id
#     subnet3 = azurerm_subnet.subnet3.id
#   }
# }