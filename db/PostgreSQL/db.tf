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

resource "azurerm_postgresql_flexible_server" "example" {
  # should be unique
  name                   = local.db_prefix
  resource_group_name    = module.resource_group.name
  location               = module.resource_group.location
  version                = var.db_version
  # by default
  # public_network_access_enabled = true
  administrator_login    = "adminuser"
  administrator_password = var.db_password
  # If the storage_mb field is undefined on the initial deployment of the PostgreSQL Flexible Server resource it will default to 32768(minimum).
  storage_mb = var.db_size_mb
  sku_name = var.db_spec
}

resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.example.id
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "example" {
  name                = "fw-${uuid()}"
  server_id         = azurerm_postgresql_flexible_server.example.id
  start_ip_address    = "0.0.0.1"
  end_ip_address      = "255.255.255.254"
}