output "id" {
  description = "The ID of the Managed Redis instance"
  value       = azurerm_managed_redis.this.id
}

output "hostname" {
  description = "The hostname of the Managed Redis instance"
  value       = azurerm_managed_redis.this.hostname
}

output "port" {
  description = "The port of the Managed Redis database"
  value       = azurerm_managed_redis.this.default_database[0].port
}

output "primary_access_key" {
  description = "The primary access key"
  value       = azurerm_managed_redis.this.default_database[0].primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key"
  value       = azurerm_managed_redis.this.default_database[0].secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string"
  value       = "${azurerm_managed_redis.this.hostname}:${azurerm_managed_redis.this.default_database[0].port},password=${azurerm_managed_redis.this.default_database[0].primary_access_key},ssl=True,abortConnect=False"
  sensitive   = true
}
