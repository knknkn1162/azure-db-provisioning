locals {
  db_vm_password = var.db_password
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
  os_disk_type = var.db_vm_os_disk_type
  os_disk_size = 128
}


module "nic4db" {
  source = "../../lib/public_nic"
  rg_name = module.resource_group.name
  rg_location = module.resource_group.location
  subnet_id = module.subnets.ids["db"]
}

locals {
  db_public_ip = module.nic4db.public_ip
  db_port=3306
  user_data =<<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y docker.io
sudo chmod 0666 /var/run/docker.sock
docker run -d -p ${local.db_port}:${local.db_port} -e MYSQL_ROOT_PASSWORD=${var.db_password} -e MYSQL_DATABASE=${var.db_name} -e MYSQL_USER=${local.admin_name} -e MYSQL_PASSWORD=${var.db_password} mysql:${var.db_version}
sudo apt-get install -y mysql-client
sleep 30
mysql --host=${local.db_public_ip} --user=${local.admin_name} --password=${var.db_password} --database=${var.db_name} --port=${local.db_port} <<-EOT
${local.sql_script}
EOT
EOF
}