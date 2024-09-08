variable "domain_prefix" {
  type = string
  default = null
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

resource "azurerm_public_ip" "example" {
  name = "pip-${uuid()}"
  resource_group_name = var.rg_name
  location = var.rg_location
  allocation_method = "Static"
  sku = "Standard"
  domain_name_label = var.domain_prefix
}

output "ip" {
  value = azurerm_public_ip.example.ip_address
}

output "id" {
  value = azurerm_public_ip.example.id
}

output "fqdn" {
  value = azurerm_public_ip.example.fqdn
}

output "domain" {
  value = azurerm_public_ip.example.domain_name_label
}