output "public_ip" {
  value = module.nic4db.public_ip
}

output "private_ip" {
  value = module.nic4db.private_ip
}

output "user_data" {
  value = local.user_data
}