
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  value = azurerm_resource_group.rg.location
}


output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = {
    subnet1 = azurerm_subnet.subnet1.id
    subnet2 = azurerm_subnet.subnet2.id
    subnet3 = azurerm_subnet.subnet3.id
  }
}


# output "service_plan_ids" {
#   value = {
#     portal_plan   = azurerm_service_plan.portal_plan.id
#     api_plan      = azurerm_service_plan.api_plan.id
#     function_plan = azurerm_service_plan.function_plan.id
#   }
# }


# output "portal_webapps" {
#   value = {
#     dev = azurerm_windows_web_app.portal_dev.name
#     uat = azurerm_windows_web_app.portal_uat.name
#   }
# }

# output "api_webapps" {
#   value = {
#     dev = azurerm_linux_web_app.api_dev.name
#     uat = azurerm_linux_web_app.api_uat.name
#   }
# }


# output "function_apps" {
#   value = {
#     dev = azurerm_windows_function_app.function_app_dev.name
#     uat = azurerm_windows_function_app.function_app_uat.name
#   }
# }


# output "storage_accounts" {
#   value = {
#     dev = azurerm_storage_account.storage_account_dev.name
#     uat = azurerm_storage_account.storage_account_uat.name
#   }
# }


# output "sql_servers" {
#   value = {
#     dev = azurerm_mssql_server.sql_server_dev.name
#     uat = azurerm_mssql_server.sql_server_uat.name
#   }
# }

# output "sql_databases" {
#   value = {
#     dev = azurerm_mssql_database.sql_database_dev.name
#     uat = azurerm_mssql_database.sql_database_uat.name
#   }
# }


# output "redis_name" {
#   value = azurerm_managed_redis.managed_redis.name
# }

# output "redis_id" {
#   value = azurerm_managed_redis.managed_redis.id
# }


# output "private_endpoint_ids" {
#   value = {
#     sql_dev = azurerm_private_endpoint.sql_dev.id
#     sql_uat = azurerm_private_endpoint.sql_uat.id
#     redis   = azurerm_private_endpoint.redis.id
#   }
# }


# output "private_dns_zones" {
#   value = {
#     sql   = azurerm_private_dns_zone.sql.name
#     redis = azurerm_private_dns_zone.redis.name
#   }
# }
