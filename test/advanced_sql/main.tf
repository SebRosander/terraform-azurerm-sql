data "http" "example" {
  url = "https://api.ipify.org"
}
module "SQL" {
  source = "../../"
  rg_name = var.rg_name
  sql_database_name = var.sql_database_name
  sql_server_name = var.sql_server_name
  storage_account_name = var.storage_account_name

  #module specific parameters
  edition                          = var.edition
  collation                        = var.collation
  failover                         = true
  identity                         = true
  firewall_ip_address              = {
    "0.0.0.0" : "255.255.255.255",
  }
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
