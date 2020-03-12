module "SQL" {
  source = "../../"
  rg_name               = "qazwsxedcrfv"
  sql_server_name       = "qazwsxedcrfv"
  sql_database_name     = "qazwsxedcrfv"
  storage_account_name  = "qazwsxedcrfv"
  #module specific parameters
  edition                          = "Basic"
}

output "SQL" {
  value = module.SQL
}
