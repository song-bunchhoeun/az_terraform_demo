output "server_id" {
  description = "The ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_ids" {
  description = "Map of database IDs"
  value       = { for k, v in azurerm_mssql_database.this : k => v.id }
}

output "database_names" {
  description = "Map of database names"
  value       = { for k, v in azurerm_mssql_database.this : k => v.name }
}
