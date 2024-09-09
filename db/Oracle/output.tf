output "public_ip" {
  value = module.nic4db.public_ip
}

output "private_ip" {
  value = module.nic4db.private_ip
}

output "user_data" {
  value = local.user_data
}

output "sqlplus_command" {
  value = "sqlplus ${local.username}/${var.db_password}@//${module.nic4db.public_ip}:${local.db_port}/${local.servicename}"
}