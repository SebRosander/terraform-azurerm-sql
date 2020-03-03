module "SQL" {
  source = "../../"

  #module specific parameters
  edition                          = var.edition
  collation                        = var.collation
  retention_days                   = var.retention_days
  requested_service_objective_name = var.requested_service_objective_name
}

output "SQL" {
  value = module.SQL
}
