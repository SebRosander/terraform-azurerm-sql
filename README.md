## Azure SQL Module ##  

This repo contains a Module to deploy a SQL Server, SQL Database, Storage Account in a Resource Group on Azure using Terraform.
The module has the possibility to create a fail-over group and a creation of a geo-redundant database for high availability needs.   

### **Latest test-run:**  
[![Build Status](https://travis-ci.com/SebRosander/terraform-azurerm-sql.svg?branch=master)](https://travis-ci.com/SebRosander/terraform-azurerm-sql)
## Provisional Instructions  
 
```
module "sql" {  
  source                = ""
  rg_name               = ""
  sql_database_name     = ""
  sql_server_name       = ""
  storage_account_name  = ""
  edition               = "" 
```

**Resource Group Inputs:**    
* `rg_name` | (Required) - String  
The name of the resource group. Must be unique on your Azure subscription.  

* `rg_location` | (Optional) - String  
The location where the resource group should be created.  
*Default: "West Europe"*  

* `rg_tags` | (Optional) - Map(string)  
A mapping of tags to assign to the resource.
________________________________________________  

**SQL Server Inputs:**  
* `sql_server_name` | (Required) - String  
The name of the SQL Server. This needs to be globally unique within Azure.   

* `sqlversion` | (Optional) - String  
The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).  
*Default: "12.0"*  

* `identity` | (Optional) - Bool  
Sets the identity type of the SQL Server to `SystemAssigned`.  
*Default: false*  

* `sql_server_tags` | (Optional) - Map(string)    
A mapping of tags to assign to the resource.    

* `failover` | (Optional) - Bool  
Creates a failover group for your Azure SQL Server.  
*Default: false*    

* `sql_server_secondary_location` | (Optional) - String  
Secondary location for SQL Server. Can't be the same location as primary server. Changing this forces a new resource to be created.  
*Default: "North Europe"*     

* `failover_mode` | (Optional) - String  
The failover mode. Possible values are Manual, Automatic.  
*Default: "Automatic"*  

* `grace_minutes` | (Optional) - Number  
Applies only if mode is Automatic. The grace period in minutes before failover with data loss is attempted.  
*Default: 60*  

* `firewall_ip_address` | (Optional) - Map(string)  
Map of the IP addresses to allow through the firewall. Key = Start IP, Value = End IP.    

* `ada` | (Optional) - Bool  
Allows you to set a user or group as the AD administrator for an Azure SQL server.  
*Default: false*  

* `ada_login` | (Optional) - String  
The login name of the principal to set as the server administrator.    

* `disabled_alerts` | (Optional) - List(any)  
Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action.  
  
* `vnet_enabled` | (Optional) - Bool  
Do you want to place your sql server/servers within a vnet?  
*Default: false*  

* `sql_vnet_rule_primary_name` | (Optional) - String  
Required if `vnet_enabled` is set to true. The name of the primary SQL virtual network rule. Changing this forces a new resource to be created. Cannot be empty and must only contain alphanumeric characters and hyphens. Cannot start with a number, and cannot start or end with a hyphen.  
  
* `subnet_id_primary` | (Optional) - String  
Required if `vnet_enabled` is set to true. The ID of the subnet that the primary SQL server will be connected to.  
  
* `sql_vnet_rule_secondary_name` | (Optional) - String  
Required if `vnet_enabled` and `failover` is set to true. The name of the secondary SQL virtual network rule. Changing this forces a new resource to be created. Cannot be empty and must only contain alphanumeric characters and hyphens. Cannot start with a number, and cannot start or end with a hyphen.  
  
* `subnet_id_secondary` | (Optional) - String  
Required if `vnet_enabled` and `failover` is set to true. The ID of the subnet that the secondary SQL server will be connected to.  
  
________________________________________________  

**SQL Database Inputs:**  
* `sql_database_name` | (Required) - String  
The name of the database.  
  
* `edition` | (Required) - String  
The edition of the database to be created. Applies only if create_mode is Default. Valid values are: Basic, Standard, Premium, or DataWarehouse.  
  
* `create_mode` | (Optional) - String  
Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup. Must be Default to create a new database.  
*Default: "Default"*    

* `source_database_id` | (Optional) - String  
The URI of the source database if create_mode value is not Default.  

* `restore_point_in_time` | (Optional) - String  
The point in time for the restore. E.g. 2013-11-08T22:00:40Z  

* `collation` | (Optional) - String  
The name of the collation. Applies only if create_mode is Default. Azure default is SQL_LATIN1_GENERAL_CP1_CI_AS. Changing this forces a new resource to be created.  

* `max_size_bytes` | (Optional) - String  
he maximum size that the database can grow to. Applies only if create_mode is Default. Please see [Azure SQL Database Service Tiers](https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-purchase-models).  

* `requested_service_objective_name` | (Optional) - String  
Set the performance level for the database. Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool.  

* `source_database_deletion_date` | (Optional) - String  
The deletion date time of the source database. Only applies to deleted databases where `create_mode` is PointInTimeRestore.  

* `elastic_pool_name` | (Optional) - String  
The name of the elastic database pool.  

* `read_scale` | (Optional) - String  
Read-only connections will be redirected to a high-available replica.  

* `zone_redundant` | (Optional) - Bool  
Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.  
*Default: false*  

* `retention_days` |  (Optional) - Number  
Specifies the number of days to keep audit logs.  
*Default: 30*  

* `use_server_default` | (Optional) - String  
Should the default server policy be used?  

* `sql_database_tags` | (Optional) - Map(string)  
A mapping of tags to assign to the resource.  

________________________________________________  

**Storage Account Inputs:**  
* `storage_account_name` | (Required) - String  
Specifies the name of the storage account to hold logs.   

* `account_replication_type` | (Optional) - String  
Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS.  
*Default: "LRS"*  

* `default_action` | (Optional) - String  
Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow.  

* `bypass` | (Optional) - List(any)  
Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.  

* `ip_rules` | (Optional) - List(any)   
List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed.  

* `virtual_network_subnet_ids` | (Optional) - List(any)  
A list of resource ids for subnets.  

* `storage_account_tags` | (Optional) - String  
A mapping of tags to assign to the resource.  
________________________________________________  

**Generic Module Variables:**  
* `email_addresses` | (Optional) - List(any)  
A list of email addresses which alerts should be sent to.  
________________________________________________

## Outputs
**Resource Group Outputs:**  
sql_rg_name  
sql_rg_location  

________________________________________________
**SQL Server Outputs:**  
sql_name  
sql_fully_qualified_domain_name  
sql_identity  
sql_admin_username  
sql_password  
sql_connection_string  
________________________________________________
**SQL Database Outputs:**  
db_id  
db_name  
db_creation_date  
sql_default_secondary_location  
________________________________________________
**Storage Account Outputs:**  
primary_blob_endpoint  
storage_account_primary_access_key
