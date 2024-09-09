output "fqdn" {
  value = azurerm_postgresql_flexible_server.example.fqdn
}

output "psql_command" {
  value = "PGPASSWORD=${var.db_password} psql -h ${azurerm_postgresql_flexible_server.example.fqdn} -U ${local.admin_name} -p ${local.db_port} -d ${var.db_name}"
}
