module "SQL" {
  source = "../../"
  rg_name               = "qazwsxedcrfv"
  sql_server_name       = "qazwsxedcrfv"
  sql_database_name     = "qazwsxedcrfv"
  storage_account_name  = "qazwsxedcrfv"
  #module specific parameters
  edition                          = "Basic"
}

data "http" "example" {
  url = "https://api.ipify.org"
}

resource "azurerm_sql_firewall_rule" "client" {
  name                = "client"
  resource_group_name = module.SQL.sql_rg_name
  server_name         = module.SQL.sql_name
  start_ip_address    = data.http.example.body
  end_ip_address      = data.http.example.body
}

output "db_name" {
  value = module.SQL.db_name
}
output "sql_name" {
  value = module.SQL.sql_name
}
output "sql_fully_qualified_domain_name" {
  value = module.SQL.sql_fully_qualified_domain_name
}
output "sql_admin_username" {
  value = module.SQL.sql_admin_username
}
output "sql_password" {
  value = module.SQL.sql_password
}