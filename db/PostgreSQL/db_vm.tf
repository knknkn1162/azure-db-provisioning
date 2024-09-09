locals {
  db_vm_password = var.db_password
  db_vm_os_disk_type = var.vm_os_disk_type
  sql_script = file("init.sql")
  admin_name = "adminuser"
}

module "db_vm" {
  source = "../../lib/vm/ubuntu"
  admin_name = "adminuser"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  size = var.db_vm_spec
  nic_id =  module.nic4db.id
  user_data = local.user_data
  password = local.db_vm_password
  os_disk_type = local.db_vm_os_disk_type
  os_disk_size = 128
}


module "nic4db" {
  source = "../../lib/public_nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["db"]
}

locals {
  container_name="postgres"
  db_public_ip = module.nic4db.public_ip
  db_port=5432
  user_data =<<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y docker.io
sudo chmod 0666 /var/run/docker.sock
docker run -p ${local.db_port}:${local.db_port} -d -e POSTGRES_USER=${local.admin_name} -e POSTGRES_DB=${var.db_name} -e POSTGRES_PASSWORD=${var.db_password} postgres:${var.db_version}
sudo apt-get install -y postgresql-client
PGPASSWORD=${var.db_password} psql -h ${local.db_public_ip} -p ${local.db_port} -U ${local.admin_name} ${var.db_name} <<-EOT
${local.sql_script}
EOT
EOF
}