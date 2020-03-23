variable "rg_name" {
  type = string
}
variable "sql_database_name" {
  type = string
}
variable "sql_server_name" {
  type = string
}
variable "storage_account_name" {
  type = string
}
# Test Specific
variable "edition" {
  description = "The edition of the database to be created. Valid values are: Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web."
  type = string
}

variable "collation" {
  description = "The name of the collation. Applies only if create_mode is Default. Azure default is SQL_LATIN1_GENERAL_CP1_CI_AS. Changing this forces a new resource to be created."
  type = string
}

variable "retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs. Defaults to 30 days."
  type = number
}

variable "requested_service_objective_name" {
  description = "Sets the performance level for the database. Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool."
}

