data "azurerm_client_config" "current" {}
data "azuread_group" "sql_admin" {
  count                        = var.ada == true ? 1 : 0
  name                         = var.ada_login
}
resource "random_uuid" "username" {}
resource "random_password" "password" {
  length                       = 32
  special                      = true
  override_special             = "_%@"
}

resource "azurerm_resource_group" "rg" {
  name                         = var.rg_name
  location                     = var.rg_location
  tags                         = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"}, var.rg_tags)
}

resource "azurerm_sql_server" "primary" {
  name                         = "${var.sql_server_name}${"-primary"}"
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
  tags                         = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"}, var.sql_server_tags)
}

resource "azurerm_sql_server" "secondary" {
  count                        = var.failover == true ? 1 : 0
  name                         = "${var.sql_server_name}${"-secondary"}"
  location                     = var.sql_server_secondary_location
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
  tags                         = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"}, var.sql_server_tags)
}

resource "azurerm_sql_firewall_rule" "firewall_primary" {
  for_each                     = var.firewall_ip_address
  name                         = each.key
  resource_group_name          = azurerm_resource_group.rg.name
  server_name                  = azurerm_sql_server.primary.name
  start_ip_address             = each.key
  end_ip_address               = each.value
}

resource "azurerm_sql_firewall_rule" "firewall_secondary" {
  for_each                     = var.failover == true ? var.firewall_ip_address : {}
  name                         = each.key
  resource_group_name          = azurerm_resource_group.rg.name
  server_name                  = azurerm_sql_server.secondary.0.name
  start_ip_address             = each.key
  end_ip_address               = each.value
}

resource "azurerm_sql_active_directory_administrator" "ada_primary" {
  count                        = var.ada == true ? 1 : 0
  server_name                  = azurerm_sql_server.primary.name
  resource_group_name          = azurerm_resource_group.rg.name
  login                        = var.ada_login
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  object_id                    = data.azuread_group.sql_admin[0].id
}

resource "azurerm_sql_active_directory_administrator" "ada_secondary" {
  count                        = var.failover == true ? var.ada == true ? 1 : 0 : 0
  server_name                  = azurerm_sql_server.secondary[0].name
  resource_group_name          = azurerm_resource_group.rg.name
  login                        = var.ada_login
  tenant_id                    = data.azurerm_client_config.current.tenant_id
  object_id                    = data.azuread_group.sql_admin[0].id
}

resource "azurerm_mssql_server_security_alert_policy" "sap_primary" {
  resource_group_name          = azurerm_resource_group.rg.name
  server_name                  = azurerm_sql_server.primary.name
  state                        = "Enabled"
  email_account_admins         = true
  email_addresses              = var.email_addresses
  retention_days               = var.retention_days
  disabled_alerts              = var.disabled_alerts
  storage_account_access_key   = azurerm_storage_account.sa.primary_access_key
  storage_endpoint             = azurerm_storage_account.sa.primary_blob_endpoint
}
resource "azurerm_mssql_server_security_alert_policy" "sap_secondary" {
  count                        = var.failover == true ? 1 : 0
  resource_group_name          = azurerm_resource_group.rg.name
  server_name                  = azurerm_sql_server.secondary.0.name
  state                        = "Enabled"
  email_account_admins         = true
  email_addresses              = var.email_addresses
  retention_days               = var.retention_days
  disabled_alerts              = var.disabled_alerts
  storage_account_access_key   = azurerm_storage_account.sa.primary_access_key
  storage_endpoint             = azurerm_storage_account.sa.primary_blob_endpoint
}

resource "azurerm_mssql_server_vulnerability_assessment" "va_primary" {
  server_security_alert_policy_id   = azurerm_mssql_server_security_alert_policy.sap_primary.id
  storage_container_path            = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc.name}/"
  storage_account_access_key        = azurerm_storage_account.sa.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.email_addresses
  }
}

resource "azurerm_mssql_server_vulnerability_assessment" "va_secondary" {
  count                             = var.failover == true ? 1 : 0
  server_security_alert_policy_id   = azurerm_mssql_server_security_alert_policy.sap_secondary.0.id
  storage_container_path            = "${azurerm_storage_account.sa.primary_blob_endpoint}${azurerm_storage_container.sc.name}/"
  storage_account_access_key        = azurerm_storage_account.sa.primary_access_key

  recurring_scans {
    enabled                   = true
    email_subscription_admins = true
    emails                    = var.email_addresses
  }
}

resource "azurerm_sql_virtual_network_rule" "sql_vnet_rule_primary" {
  count                      = var.vnet_enabled == true ? 1 : 0
  name                       = var.sql_vnet_rule_primary_name
  resource_group_name        = azurerm_resource_group.rg.name
  server_name                = azurerm_sql_server.primary.name
  subnet_id                  = var.subnet_id_primary
}
resource "azurerm_sql_virtual_network_rule" "sql_vnet_rule_secondary" {
  count                      = var.vnet_enabled == true ? var.failover == true ? 1 : 0 : 0
  name                       = var.sql_vnet_rule_secondary_name
  resource_group_name        = azurerm_resource_group.rg.name
  server_name                = azurerm_sql_server.secondary.0.name
  subnet_id                  = var.subnet_id_secondary
}

resource "azurerm_sql_database" "sql" {
  name                              = var.sql_database_name
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  server_name                       = azurerm_sql_server.primary.name
  create_mode                       = var.create_mode
  source_database_id                = var.source_database_id == null ? null : var.source_database_id
  restore_point_in_time             = var.source_database_id == null ? null : var.restore_point_in_time == null ? null : var.restore_point_in_time
  edition                           = var.source_database_id == null ? var.edition : null
  collation                         = var.source_database_id == null ? var.collation : null
  max_size_bytes                    = var.source_database_id == null ? var.max_size_bytes : null
  requested_service_objective_name  = var.requested_service_objective_name
  source_database_deletion_date     = var.create_mode == "PointInTimeRestore" ? var.source_database_deletion_date : null
  elastic_pool_name                 = var.elastic_pool_name
  read_scale                        = var.read_scale
  zone_redundant                    = var.zone_redundant
    threat_detection_policy {
      state                         = "Enabled"
      email_account_admins          = "Enabled"
      email_addresses               = var.email_addresses
      retention_days                = var.retention_days
      storage_account_access_key    = azurerm_storage_account.sa.primary_access_key
      storage_endpoint              = azurerm_storage_account.sa.primary_blob_endpoint
      use_server_default            = var.use_server_default
    }
  tags                              = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"}, var.sql_database_tags)
}

resource "azurerm_storage_account" "sa" {
  name                              = lower(substr(var.storage_account_name, 0, min(length("${var.sql_server_name}-logs"),23)))
  location                          = azurerm_resource_group.rg.location
  resource_group_name               = azurerm_resource_group.rg.name
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = var.account_replication_type
  enable_https_traffic_only         = true
  tags                              = merge({"Created by":"Sebrosander", "Github":"https://github.com/SebRosander", "SQL":"Module"}, var.storage_account_tags)
}

resource "azurerm_storage_container" "sc" {
  name                             = "vulnerability-assessment"
  storage_account_name             = azurerm_storage_account.sa.name
  container_access_type            = "private"
}

resource "azurerm_advanced_threat_protection" "storage" {
  target_resource_id              = azurerm_storage_account.sa.id
  enabled                         = true
}

resource "azurerm_storage_account_network_rules" "rules" {
  count                          = var.default_action == null ? 0 : 1
  resource_group_name            = azurerm_resource_group.rg.name
  storage_account_name           = azurerm_storage_account.sa.name
  default_action                 = var.default_action
  bypass                         = var.bypass
  ip_rules                       = var.ip_rules
  virtual_network_subnet_ids     = var.virtual_network_subnet_ids
}