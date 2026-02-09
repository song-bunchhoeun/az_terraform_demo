
## Network Infrastructure
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-sea-001"
  address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location   
    resource_group_name = azurerm_resource_group.rg.name
}

# Subnet1
resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet2
resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Subnet3
resource "azurerm_subnet" "subnet3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

## Network Security Groups
# Front Door (Standard tier)
resource "azurerm_network_security_group" "nsg_frontdoor" {
  name                = "${var.prefix}-afd-global-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# WAF Policy 
resource "azurerm_network_security_group" "nsg_wafpolicy" {
  name                = "${var.prefix}-waf-global-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Front Door Origin Groups
resource "azurerm_network_security_group" "nsg_frontdoor_origin" {
  name                = "${var.prefix}-fdog-sea-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Routing (DEV)
resource "azurerm_network_security_group" "nsg_routing_dev" {
  name                = "${var.prefix}-rt-dev-sea-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# Routing (UAT)
resource "azurerm_network_security_group" "nsg_routing_uat" {
  name                = "${var.prefix}-rt-uat-sea-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# ## API & Integration
# # API management (Developer tier)
# resource "azurerm_api_management" "api_mgmt" {
#   name                = "apim-ekyc-nonprod-sea-002"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   publisher_name      = "apim-ekyc-nonprod"
#   publisher_email     = "ekyc@dgc.com"
#   sku_name            = "Developer_1"
# }

# # API management APIs (Dev, UAT)
# resource "azurerm_api_management_api" "api_mgmt_apis" {
#   count               = 2
#   name                = "api-ekyc-nonprod-${count.index + 1}"
#   resource_group_name = azurerm_resource_group.rg.name
#   api_management_name = azurerm_api_management.api_mgmt.name
#   revision            = "1"
#   display_name        = "eKYC NonProd API ${count.index + 1}"
#   path                = "ekyc-nonprod-api-${count.index + 1}"
#     protocols           = ["https"]
#     service_url        = "https://ekyc-nonprod-backend-${count.index + 1}.azurewebsites.net"
# }

## Compute App Services
#App Service Plan (B1 Basic tier portal instance)
# resource "azurerm_service_plan" "portal_plan" {
#   name                = "plan-ekyc-nonprod-sea-001"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   os_type             = "Windows"
#   sku_name            = "B1"
# }

# resource "azurerm_service_plan" "api_plan" {
#   name                = "plan-ekyc-nonprod-sea-002"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   os_type             = "Linux"
#   sku_name            = "B1"
# }

# resource "azurerm_service_plan" "function_plan" {
#   name                = "plan-ekyc-nonprod-sea-003"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   os_type             = "Windows"
#   sku_name            = "FC1"
# }

# App Service (Portal)
# resource "azurerm_windows_web_app" "portal_dev" {
#   name                = "app-ekyc-portal-dev-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.portal_plan.id

#   site_config {
#     application_stack {
#       dotnet_version = "v4.0"
#     }
#   }

#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#   }
# }


# resource "azurerm_windows_web_app" "portal_uat" {
#   name                = "app-ekyc-portal-uat-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.portal_plan.id

#   site_config {
#     application_stack {
#       dotnet_version = "v4.0"
#     }
#   }
#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#   }
# }

# # App Service (API)
# resource "azurerm_linux_web_app" "api_dev" {
#   name                = "app-ekyc-api-dev-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.api_plan.id

#   site_config {
#     application_stack {
#       dotnet_version = "8.0"
#     }
#   }

#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#   }
# }

# resource "azurerm_linux_web_app" "api_uat" {
#   name                = "app-ekyc-api-uat-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.api_plan.id

#   site_config {
#     application_stack {
#       dotnet_version = "8.0"
#     }
#   }

#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#   }
# }



# ## Serverless Compute
# # Function App (Dev for widnows)
# resource "azurerm_windows_function_app" "function_app_dev" {
#   name                = "func-ekyc-dev-sea-002"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.function_plan.id

#   storage_account_name       = azurerm_storage_account.storage_account_dev.name
#   storage_account_access_key = azurerm_storage_account.storage_account_dev.primary_access_key

#   site_config {
#     application_stack {
#       dotnet_version = "v8.0"
#     }
#   }

#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#     FUNCTIONS_EXTENSION_VERSION = "~4"
#   }
# }

# # Function App (UAT for widnows)
# resource "azurerm_windows_function_app" "function_app_uat" {
#   name                = "func-ekyc-uat-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.function_plan.id

#   storage_account_name       = azurerm_storage_account.storage_account_uat.name
#   storage_account_access_key = azurerm_storage_account.storage_account_uat.primary_access_key

#   site_config {
#     application_stack {
#       dotnet_version = "v8.0"
#     }
#   }

#   app_settings = {
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#     FUNCTIONS_EXTENSION_VERSION = "~4"
#   }
# }


# # Storage Account (Dev Function App)
# resource "azurerm_storage_account" "storage_account_dev" {
#   name                     = "stekycnonproddev${random_string.sa_suffix.result}"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# # storage accout for Function App UAT
# resource "azurerm_storage_account" "storage_account_uat" {
#   name                     = "stekycnonproduat${random_string.sa_suffix.result}"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# ## Data & Cache
# # SQL Server (DEV)
# resource "azurerm_mssql_server" "sql_server_dev" {
#   name                         = "sql-ekyc-dev-sea-002"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = azurerm_resource_group.rg.location
#   version                      = "12.0"
#   administrator_login          = "sqladminuser"
#   administrator_login_password = "P@ssw0rd1234!"
# }

# resource "azurerm_mssql_database" "sql_database_dev" {
#   name                = "db-ekyc-nonprod-001"
#   server_id           = azurerm_mssql_server.sql_server_dev.id
#   collation           = "SQL_Latin1_General_CP1_CI_AS"
#   max_size_gb         = 10
#   sku_name            = "S0"
# }

# # SQL Server (UAT)
# resource "azurerm_mssql_server" "sql_server_uat" {
#   name                         = "sql-ekyc-uat-sea-001"
#   resource_group_name          = azurerm_resource_group.rg.name
#   location                     = azurerm_resource_group.rg.location
#   version                      = "12.0"
#   administrator_login          = "sqladminuser"
#   administrator_login_password = "P@ssw0rd1234!"
#   public_network_access_enabled = false
# }

# # SQL Database (UAT)
# resource "azurerm_mssql_database" "sql_database_uat" {
#   name                = "db-ekyc-nonprod-001"
#   server_id           = azurerm_mssql_server.sql_server_uat.id
#   collation           = "SQL_Latin1_General_CP1_CI_AS"
#   max_size_gb         = 10
#   sku_name            = "S0"
  
# }

# # SQL Firewall Rule
# resource "azurerm_mssql_firewall_rule" "sql_firewall_rule" {
#   name       = "allow-all"
#   server_id  = azurerm_mssql_server.sql_server_dev.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "255.255.255.255"
# }

# # Azure managed Redis

# resource "random_string" "redis_suffix" {
#   length  = 4
#   upper   = false
#   special = false
# }

# resource "azurerm_managed_redis" "managed_redis" {
#   name                = "redis-ekyc-nonprod-${random_string.redis_suffix.result}"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku_name            = "Balanced_B0"  
#   tags = {
#     environment = "nonprod"
#     project     = "eKYC"
#   }
# }

# # Private dns zones and private endpoints
# resource "azurerm_private_dns_zone" "sql" {
#   name                = "privatelink.database.windows.net"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_private_dns_zone" "redis" {
#   name                = "privatelink.redis.azure.net"
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_private_endpoint" "sql_dev" {
#   name                = "pe-sql-dev-ekyc-nonprod-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet1.id

#   private_service_connection {
#     name                           = "psc-sql-dev-ekyc-nonprod-sea-001"
#     private_connection_resource_id = azurerm_mssql_server.sql_server_dev.id
#     subresource_names              = ["sqlServer"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "pdzg-sql-dev-ekyc-nonprod-sea-001"
#     private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
#   }
# }

# # Private Endpoints (SQL, Redis)
# resource "azurerm_private_endpoint" "sql_uat" {
#   name                = "pe-sql-uat-ekyc-nonprod-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet2.id
#   private_service_connection {
#     name                           = "psc-sql-uat-ekyc-nonprod-sea-001"
#     private_connection_resource_id = azurerm_mssql_server.sql_server_uat.id
#     subresource_names              = ["sqlServer"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "pdzg-sql-uat-ekyc-nonprod-sea-001"
#     private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
#   }
# }

# resource "azurerm_private_endpoint" "redis" {
#   name                = "pe-redis-ekyc-nonprod-sea-001"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = azurerm_subnet.subnet3.id

#   private_service_connection {
#     name                           = "psc-redis-ekyc-nonprod-sea-001"
#     private_connection_resource_id = azurerm_managed_redis.managed_redis.id
#     subresource_names              = ["redisEnterprise"]
#     is_manual_connection           = false
#   }

#   private_dns_zone_group {
#     name                 = "pdzg-redis"
#     private_dns_zone_ids = [azurerm_private_dns_zone.redis.id]
#   }
# }

