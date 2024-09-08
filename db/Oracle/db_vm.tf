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

# for Oracle
locals {
  container_name = "orac"
  db_port = 1521
  db_em_port = 5500
  docker_image = "container-registry.oracle.com/database/express:21.3.0-xe"
  wait_time = 240
  username = "system"
  servicename = "XE"
  user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y docker.io
sudo chmod 0666 /var/run/docker.sock
# -d: daemon
docker run -d  -p ${local.db_port}:${local.db_port} -p ${local.db_em_port}:${local.db_em_port} \
  -e PWD=${var.db_password} --name ${local.container_name} ${local.docker_image}
sleep ${local.wait_time}
ID=`docker container inspect ${local.container_name} --format={{.Id}}`
docker exec $ID /bin/bash -c "sqlplus ${local.username}/${var.db_password}@${local.servicename} <<-EOT
${local.sql_script}
EOT
"
EOF
}
