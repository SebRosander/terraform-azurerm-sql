module "SQL" {
  source = "../../"

  #module specific parameters
  edition                          = "Basic"
}

output "SQL" {
  value = module.SQL
}
