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

output "psql_command" {
  value = "PGPASSWORD=${var.db_password} psql -h ${local.db_public_ip} -p ${local.db_port} -U ${local.admin_name} ${var.db_name}"
}