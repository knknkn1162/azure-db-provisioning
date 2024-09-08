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
variable "db_version" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_size" {
  type = number
}

variable "db_sku" {
  type = string
}

variable "client_vm_spec" {
  type = string
}