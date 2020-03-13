# Resource group output
output "sql_rg_name" {
  value = azurerm_resource_group.rg.name
}
output "sql_rg_location" {
  value = azurerm_resource_group.rg.location
}

# Primary SQL Server Outputs
output "sql_name" {
  value = azurerm_sql_server.primary.name
}
output "sql_fully_qualified_domain_name" {
  value = azurerm_sql_server.primary.fully_qualified_domain_name
}
output "sql_identity" {
  value = var.identity == true ? azurerm_sql_server.primary.identity : null
}
output "sql_default_secondary_location" {
  value = azurerm_sql_database.sql.default_secondary_location
}
output "sql_admin_username"{
  value       = azurerm_sql_server.primary.administrator_login
  sensitive   = true
}
output "sql_password" {
  value       = azurerm_sql_server.primary.administrator_login_password
  sensitive   = true
}
output "sql_connection_string" {
  value = "Server=tcp:${azurerm_sql_server.primary.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.sql.name};Persist Security Info=False;User ID=${azurerm_sql_server.primary.administrator_login};Password=${azurerm_sql_server.primary.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive = true
}

# SQL Database Outputs
output "db_id" {
  value = azurerm_sql_database.sql.id
}
output "db_name" {
  value = azurerm_sql_database.sql.name
}
output "db_creation_date" {
  value = azurerm_sql_database.sql.creation_date
}

# Blob outputs
output "primary_blob_endpoint" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}
output "azureblob_primary_key" {
  value = azurerm_storage_account.sa.primary_access_key
}