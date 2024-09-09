# number and upper only
module "random" {
  source = "../../lib/random"
  length = 16
  is_upper = false
}

locals {
  admin_name = "adminuser"
  db_prefix = module.random.result
}

resource "azurerm_mssql_server" "example" {
  # "name" can contain only lowercase letters, numbers, and '-',
  # but can't start or end with '-' or have more than 63 characters.
  name                         = local.db_prefix
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location
  version                      = var.db_version
  administrator_login          = local.admin_name
  administrator_login_password = var.db_password
  minimum_tls_version          = "Disabled"
  # default to true
  #public_network_access_enabled = false
}

resource "azurerm_mssql_database" "example" {
  name           = var.db_name
  server_id      = azurerm_mssql_server.example.id
  collation      = "SQL_Latin1_General_CP1_CI_AI"
  sku_name = var.db_sku
  zone_redundant = false
  geo_backup_enabled = false
  storage_account_type = "Local"
  # prevent the possibility of accidental data loss
  #lifecycle {
  #  prevent_destroy = true
  #}
}

# for test
resource "azurerm_mssql_firewall_rule" "example" {
  name = "fw-${uuid()}"
  server_id = azurerm_mssql_server.example.id
  start_ip_address = "0.0.0.1"
  end_ip_address = "255.255.255.254"
}

# To avoid the error to access from client_vm
resource "azurerm_mssql_virtual_network_rule" "example" {
  name      = "${local.db_prefix}-sql-vnet-rule"
  server_id = azurerm_mssql_server.example.id
  subnet_id = module.subnets.ids["db"]
}
