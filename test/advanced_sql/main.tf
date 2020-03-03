
module "SQL" {
  source = "../../"

  #module specific parameters
  edition                          = var.edition
  collation                        = var.collation
  retention_days                   = var.retention_days
  identity                         = true
}

output "SQL" {
  value = module.SQL
}