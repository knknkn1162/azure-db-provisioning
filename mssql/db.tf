module "random" {
  source = "../lib/random"
  length = 12
}

locals {
  admin_name = "adminuser"
  db_prefix = module.random.result
}

resource "azurerm_mssql_server" "example" {
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
  # to db cost.(In azure marketplace, S3 is used)
  max_size_gb = var.db_size
  sku_name = var.db_sku
  zone_redundant = false
  geo_backup_enabled = false
  storage_account_type = "Local"
  # prevent the possibility of accidental data loss
  #lifecycle {
  #  prevent_destroy = true
  #}
}

# To avoid the below error
# Cannot open server 'var.db_prefix' requested by the login.
# Client with IP address '***' is not allowed to access the server.
# To enable access, use the Azure Management Portal or run sp_set_firewall_rule on the master database to create a firewall rule for this IP address or address range.
# It may take up to five minutes for this change to take effect
resource "azurerm_mssql_virtual_network_rule" "example" {
  name      = "${local.db_prefix}-sql-vnet-rule"
  server_id = azurerm_mssql_server.example.id
  subnet_id = module.subnets.ids["db"]
}

