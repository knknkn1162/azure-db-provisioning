variable "subscription_id" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "db_cidr" {
  type = string
}
variable "db_spec" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_size_mb" {
  type = number
}

variable "db_version" {
  type = string
}

variable "db_password" {
  type = string
}

variable "client_vm_spec" {
  type = string
}

variable "vm_os_disk_type" {
  type = string
}

variable "db_vm_spec" {
  type = string
}