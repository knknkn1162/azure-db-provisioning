locals {
  client_vm_password = var.db_password
  sql_script = file("init.sql")
  vm_admin_name = local.admin_name
  db_port = 5432
}

module "client_vm" {
  source = "../../lib/vm/ubuntu"
  admin_name = local.vm_admin_name
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  size = var.client_vm_spec
  nic_id =  module.nic4db.id
  password = local.client_vm_password
  os_disk_type = "Standard_LRS"
  os_disk_size = 64
  user_data = <<-EOF
#!/bin/bash
## install sqlcmd for SQL Server
sudo apt-get install -y postgresql-client
PGPASSWORD=${var.db_password} psql -h ${local.db_prefix}.postgres.database.azure.com -p ${local.db_port} -U ${local.admin_name} ${var.db_name} <<-EOT
${local.sql_script}
EOT
EOF
  depends_on = [
    azurerm_postgresql_flexible_server.example,
    azurerm_postgresql_flexible_server_firewall_rule.example,
  ]
}

module "nic4db" {
  source = "../../lib/public_nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["db"]
}
