# azurerm_resource_group.rg variables
variable "rg_name" {
  description = "The name of the resource group. Must be unique on your Azure subscription." 
  type = string
}
variable "rg_location" {
  description = 
  type = string
  default = "westeurope"
}
variable "rg_tag" {
  description = "A mapping of tags to assign to the resource."
  type = map(string)
  default = {}
}

# azurerm_sql_server.primary
variable "sql_server_name" {
  description = "The name of the SQL Server. This needs to be globally unique within Azure."
  type = string
}
variable "sqlversion" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  type = string 
  default = "12.0"
}
variable "identity" {
  description = "If you want your SQL Server to have an managed identity. Defaults to false."
  type = bool
  default = false  
}
variable "sql_server_tags" {
  description = "A mapping of tags to assign to the resource."
  type = map(string)
  default = {}
}

# azurerm_sql_server.secondary
variable "failover" {
  description = "Do you want to create a failover for your Azure SQL server?"
  type = bool
  default = false
}
variable "sql_server_secondary_location" {
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type = string
  default = "northeurope"
}

# azurerm_sql_active_directory_administrator
variable "ada" {
  description = "Allows you to set a user or group as the AD administrator for an Azure SQL server"
  type = bool
  default = false
}
variable "ada_login" {
  description = "The login name of the principal to set as the server administrator"
  type = string
  default = null
}

# azurerm_mssql_server_security_alert_policy.sap
variable "disabled_alerts" {
  description = "Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action."
  type = list(any)
  default = []
}

# azurerm_sql_virtual_network_rule.sqlvnetrule_primary
variable "vnet_enabled" {
  description = "Do you want to place your sql server/servers within a vnet?"
  type = bool
  default = false
}
variable "sql_vnet_rule_primary_name" {
  description = "The name of the primary SQL virtual network rule. Changing this forces a new resource to be created. Cannot be empty and must only contain alphanumeric characters and hyphens. Cannot start with a number, and cannot start or end with a hyphen."
  type = string
  default = null
}
variable "subnet_id_primary" {
  description = "The ID of the subnet that the primary SQL server will be connected to."
  type = string
  default = null
}

# azurerm_sql_virtual_network_rule.sql_vnet_rule_secondary
variable "sql_vnet_rule_secondary_name" {
  description = "The name of the secondary SQL virtual network rule. Changing this forces a new resource to be created. Cannot be empty and must only contain alphanumeric characters and hyphens. Cannot start with a number, and cannot start or end with a hyphen."
  type = string
  default = null
}
variable "subnet_id_secondary" {
  description = "The ID of the subnet that the secondary SQL server will be connected to."
  type = string
  default = null
}

# azurerm_sql_database.sql 
variable "sql_database_name" {
  description = ""
  type = string
}
variable "create_mode" {
  description = "Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup. Must be Default to create a new database. Defaults to Default."
  type = string
  default = "Default"
}
variable "source_database_id" {
  description = "The URI of the source database if create_mode value is not Default."
  type = string
  default = null
}
variable "restore_point_in_time" {
  description = "The point in time for the restore. E.g. 2013-11-08T22:00:40Z"
  type = string
  default = null
}
variable "edition" {
  description = "The edition of the database to be created. Applies only if create_mode is Default. Valid values are: Basic, Standard, Premium, or DataWarehouse."
  type = string
}
variable "collation" {
  description = "The name of the collation. Applies only if create_mode is Default. Azure default is SQL_LATIN1_GENERAL_CP1_CI_AS. Changing this forces a new resource to be created."
  type = string
  default = null
}
variable "max_size_bytes" {
  description = "The maximum size that the database can grow to. Applies only if create_mode is Default. Please see link for more information"
  type = number
  default = null
}
variable "requested_service_objective_name" {
  description = "Set the performance level for the database. Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool."
  type = string
  default = null
}
variable "source_database_deletion_date" {
  description = "The deletion date time of the source database. Only applies to deleted databases where"
  type = string
  default = null
}
variable "elastic_pool_name" {
  description = "The name of the elastic database pool."
  type = string
  default = null
}
variable "read_scale" {
  description = "Read-only connections will be redirected to a high-available replica."
  type = string
  default = null
}
## azurerm_sql_database.sql || threath_detection_policy 

variable "retention_days" {
  description = "Specifies the number of days to keep audit logs."
  type = number
  default = 30
}
variable "use_server_default" {
  description = "Should the default server policy be used?"
  type = string
  default = null
}

# azurerm_storage_account.sa
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  type = string
  default = "LRS"  
}

# azurerm_storage_account_network_rules.rules
variable "default_action" {
  type = string
  description = "Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
  default = null
}
variable "bypass" {
  type = list(any)
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  default = null
}
variable "ip_rules" {
  type = list(any)
  description = "List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed."
  default = []
}
variable "virtual_network_subnet_ids" {
  type = list(any)
  description = "A list of resource ids for subnets."
  default = null
}


# Generic Module Variables
variable "email_addresses" {
  description = "A list of email addresses which alerts should be sent to."
  type = list(any)
  default = []
}