locals {
  client_vm_password = var.db_password
  sql_script = file("init.sql")
  vm_admin_name = local.admin_name
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
curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> /home/${local.admin_name}/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bash_profile
source ~/.bash_profile
## inject SQL queries
/opt/mssql-tools18/bin/sqlcmd -S ${local.db_prefix}.database.windows.net,1433 -U ${local.admin_name} -d ${var.db_name} -P ${var.db_password} -C <<-EOT
${local.sql_script}
EOT
EOF
  depends_on = [
    azurerm_mssql_database.example,
    azurerm_mssql_virtual_network_rule.example,
  ]
}

module "nic4db" {
  source = "../../lib/public_nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["db"]
}
