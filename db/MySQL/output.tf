output "public_ip" {
  value = module.nic4db.public_ip
}

output "private_ip" {
  value = module.nic4db.private_ip
}

output "ssh" {
  value = "ssh ${local.admin_name}@${local.db_public_ip}"
}

output "sshpass" {
  value = "sshpass -p${var.db_password} ssh ${local.admin_name}@${local.db_public_ip}"
}

output "mysql_command" {
  value = "mysql --host=${local.db_public_ip} --user=${local.admin_name} --password=${var.db_password} --database=${var.db_name} --port=${local.db_port}"
}