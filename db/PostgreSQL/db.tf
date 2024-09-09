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

resource "azurerm_postgresql_server" "example" {
  name                = local.db_prefix
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  administrator_login          = local.admin_name
  administrator_login_password = var.db_password

  sku_name   = var.db_spec
  version    = var.db_version
  storage_mb = var.db_size_mb
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = false
  # ssl_minimal_tls_version_enforced must be set to TLSEnforcementDisabled when ssl_enforcement_enabled is set to false.
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
}

resource "azurerm_postgresql_database" "example" {
  name                = var.db_name
  resource_group_name = module.resource_group.name
  server_name         = azurerm_postgresql_server.example.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  # prevent the possibility of accidental data loss
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "azurerm_postgresql_firewall_rule" "example" {
  name                = "fw-${uuid()}"
  resource_group_name = module.resource_group.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "0.0.0.1"
  end_ip_address      = "255.255.255.254"
}