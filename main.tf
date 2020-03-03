resource "azurerm_resource_group" "rg" {
  name     = ""
  location = var.location
  tags                         = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"} /*var.tag*/)
}

resource "random_password" "password" {
  length = 32
  special = true
  override_special = "_%@"
}

resource "random_uuid" "username" {}

# create a variable for tags. Remember to assign created by 
resource "azurerm_sql_server" "sqlserver" {
  name                         = local.namebase
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = var.sqlversion
  administrator_login          = random_uuid.username.result
  administrator_login_password = random_password.password.result
  dynamic "identity" {
    for_each                   = var.identity == true ? [1] : [0] 
    content                    {
      type                     = "SystemAssigned"
    }
  }
  tags                         = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"} /*var.tag*/)
}

#Create a variable for email_addresses 
resource "azurerm_mssql_server_security_alert_policy" "sap" {
  resource_group_name          = azurerm_resource_group.rg.name
  server_name                = azurerm_sql_server.sqlserver.name
  state                      = "Enabled"
  disabled_alerts            = var.disabled_alerts
  email_account_admins       = true
  email_addresses            = [""]
  retention_days             = var.retention_days
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  storage_endpoint           = azurerm_storage_account.sa.primary_blob_endpoint
}

## Create a variable for emails
resource "azurerm_mssql_server_vulnerability_assessment" "va" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.sap.id
  storage_container_path = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc.name}/"
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = 
  }
}
## Create a variable for vnet name and subnetid. 
resource "azurerm_sql_virtual_network_rule" "sqlvnetrule" {
  name                = ""
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlserver.name
  subnet_id           = ""
}

# Create a varable for name and email:addresses
resource "azurerm_sql_database" "sql" {
  name                              = ""
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  server_name                       = azurerm_sql_server.sqlserver.name
  create_mode                       = var.create_mode
  source_database_id                = var.source_database_id == null ? null : var.source_database_id
  restore_point_in_time             = var.source_database_id == null ? null : var.restore_point_in_time == null ? null : var.restore_point_in_time
  edition                           = var.source_database_id == null ? var.edition : null
  collation                         = var.source_database_id == null ? var.collation : null
  max_size_bytes                    = var.source_database_id == null ? var.max_size_bytes : null
  requested_service_objective_name  = var.requested_service_objective_name
  source_database_deletion_date     = var.source_database_id == null ? null : var.source_database_deletion_date
  elastic_pool_name                 = var.elastic_pool_name
  read_scale                        = var.read_scale
    threat_detection_policy {
      state                         = "Enabled"
      email_account_admins          = "Enabled"
      email_addresses               = [""]
      retention_days                = var.retention_days
      storage_account_access_key    = azurerm_storage_account.sa.primary_access_key
      storage_endpoint              = azurerm_storage_account.sa.primary_blob_endpoint
      use_server_default            = var.use_server_default
    }
  tags                              = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"} /*var.tag*/)
}

# Create a variable for name, make sure it's lowercase and not going over 24 characters. 
resource "azurerm_storage_account" "sa" {
  name                              = ""
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = var.account_replication_type
  enable_https_traffic_only         = true
  tags                              = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"} /*var.tag*/)
}

# Create a variable for name
resource "azurerm_storage_container" "sc" {
  name                      = ""
  storage_account_name      = azurerm_storage_account.sa.name
  container_access_type     = "private"
}

resource "azurerm_advanced_threat_protection" "storage" {
  target_resource_id        = azurerm_storage_account.sa.id
  enabled                   = true
}

resource "azurerm_storage_account_network_rules" "rules" {
  count                      = var.default_action == null ? 0 : 1
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.sa.name
  default_action             = var.default_action
  bypass                     = var.bypass
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
}