variable "rg_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "domain_prefix" {
  type = string
  default = null
}

locals {
  name = "nic-${uuid()}"
}

module "pip" {
  source = "../pip"
  rg_location = var.rg_location
  rg_name = var.rg_location
  domain_prefix = var.domain_prefix
}

resource "azurerm_network_interface" "example" {
  name = local.name
  location = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name = "ipconf-${local.name}"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = module.pip.id
  }
}

output "id" {
  value = azurerm_network_interface.example.id
}

output "public_ip" {
  value = module.pip.ip
}

output "private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "fqdn" {
  value = module.pip.fqdn
}

output "domain" {
  value = module.pip.domain
}