variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "cidr" {
    type = string
}

resource "azurerm_virtual_network" "example" {
  name                = "vn-${var.rg_name}"
  address_space       = [var.cidr]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

output "name" {
    value = azurerm_virtual_network.example.name
}

output "id" {
    value = azurerm_virtual_network.example.id
}