output "fqdn" {
  value = azurerm_mssql_server.example.fully_qualified_domain_name
}

output "sqlcmd_command" {
  value = "sqlcmd -S ${local.db_prefix}.database.windows.net,${local.db_port} -U ${local.admin_name} -d ${var.db_name} -P ${var.db_password} -C"
}