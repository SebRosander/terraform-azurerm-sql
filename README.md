## Azure SQL Module ##  

This repo contains a Module to deploy a SQL Server, as well as a SQL Database on Azure using Terraform.

### **Latest testrun:**  

## Provisional Instructions  
 
```
module "sql" {  
  source = ""
  #module specific parameters
  edition                          = "Basic" 
```

**Required Inputs**  
________________________________________________  
* `edition` | string - The edition of the database to be created.  Valid values are: Basic, Standard, Premium, DataWarehouse, Business, BusinessCritical, Free, GeneralPurpose, Hyperscale, Premium, PremiumRS, Standard, Stretch, System, System2, or Web. Please see [Azure SQL Database Service Tiers](https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-purchase-models) | **NOTE:** *Not applicable if you are doing a point in time restore.*  

**Dependant Required Inputs**
_________________________  

* `source_database_id` | string  
Description: The URI of the source database. **NOTE:** *ONLY applicable if you are doing a point in time restore*

* `restore_point_in_time` | string  
Description: The point in time for the restore. E.g. 2013-11-08T22:00:40Z **NOTE:** *ONLY applicable if you are doing a point in time restore*  

* `default_action` | string 
Description: Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow. **NOTE:** This is required if you want to set `ip_rules`, `bypass` or `virtual_network_subnet_ids`


**Optional Inputs**  
__________________________________________________  
<details closed>
<summary>Click here to see optional inputs</summary>  

* `identity` | bool  
Description: If you want your SQL Server to have an managed identity.  
Defaults to false.  

* `sqlversion` | string  
Description: The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Defaults to "12.0"

* `create_mode` | string
Description: Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup. Must be Default to create a new database. Defaults to Default. Please see [Azure SQL Database REST API](https://docs.microsoft.com/en-us/rest/api/sql/databases/createorupdate#createmode) for more information.

* `collation` | string  
Description: The name of the collation. Applies only if create_mode is Default. Azure default is SQL_LATIN1_GENERAL_CP1_CI_AS. Changing this forces a new resource to be created.

* `max_size_bytes` | string  
Description: The maximum size that the database can grow to. **NOTE:** *Not applicable if you are doing a point in time restore.* 

* `requested_service_objective_name` | string  
Description: Sets the performance level for the database. Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool. Please see [Azure SQL Database Service Tiers](https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-purchase-models).

* `source_database_deletion_date` | string  
Description: The maximum size that the database can grow to. **NOTE:** *ONLY applicable if you are doing a point in time restore*

* `elastic_pool_name` | string  
Description: The name of the elastic database pool.  

* `read_scale` | string  
Description: Read-only connections will be redirected to a high-available replica. Please see [Use read-only replicas to load-balance read-only query workloads](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-read-scale-out).  

**Threat Detection Policy**
* `retention_days` | number  
Description: Specifies the number of days to keep in the Threat Detection audit logs. Defaults to 30 days. **NOTE:** *Do not change this value unless SecOps or IT - Security Department gives other directives.*

* `use_server_default` | string  
Description: Should the default server policy be used?

**Blob Storage Variables**  

* `account_replication_type` | string   
Description: Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS.  
Default: LRS  

* `bypass` | list(any)  
Description: Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.  

* `ip_rules` | list(any)  
Description: List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed. Folksams public IP-pool is added by default.  

* `virtual_network_subnet_ids` | list(any)  
Description: A list of resource ids for subnets.  

</details>

## Outputs
sql_rg_name    
sql_rg_location    
sql_name    
sql_fully_qualified_domain_name    
sql_identity    
sql_default_secondary_location    
sql_connection_string     
sql_name  
db_id   
db_name  
db_creation_date  
primary_blob_endpoint   
azureblob_primary_key    