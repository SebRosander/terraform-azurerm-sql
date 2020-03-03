# Generic Module Variables
variable "identity" {
  description = "If you want your SQL Server to have an managed identity. Defaults to false."
  type = bool
  default = false  
}

variable "sqlversion" {
  description = "The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  type = string 
  default = "12.0"
}

variable "source_database_id" {
  description = "The URI of the source database if create_mode value is not Default."
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
  description = "Read-only connections will be redirected to a high-available replica. Please see link for more information"
  type = string
  default = null
}
variable "restore_point_in_time" {
  description = "The point in time for the restore. E.g. 2013-11-08T22:00:40Z"
  type = string
  default = null
}
variable "create_mode" {
  description = "Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup. Must be Default to create a new database. Defaults to Default."
  type = string
  default = "Default"
}

#Threat Detection Policy
variable "retention_days" {
  description = "Specifies the number of days to keep in the Threat Detection audit logs."
  type = number
  default = 30
}

variable "storage_account_access_key" {
  description = "Specifies the identifier key of the Threat Detection audit storage account. Required if state is Enabled."
  type = string
  default = null
}

variable "storage_container_path" {
  description = "A blob storage container path to hold the scan results (e.g. https://myStorage.blob.core.windows.net/VaScans/)."
  type = string
  default = null
}

variable "storage_endpoint" {
  description = "Specifies the blob storage endpoint (e.g. https://MyAccount.blob.core.windows.net). This blob storage will hold all Threat Detection audit logs. If you already have a blob storage, enter information here. Otherwise leave this blank."
  type = string
  default = null
}

variable "disabled_alerts" {
  description = "Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action."
  type = list(any)
  default = []
}

variable "use_server_default" {
  description = "Should the default server policy be used?"
  type = string
  default = null
}


#blobstorage
variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS."
  type = string
  default = "LRS"  
}
#Network for blobstorage
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