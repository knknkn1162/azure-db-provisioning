
variable "rg_name" {
    type = string
}

variable "rg_location" {
    type = string
}

variable "dst_port2priority" {
  type = map(string)
}

variable "subnet_id" {
  type = string
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-${uuid()}"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_network_security_rule" "example" {
  for_each = var.dst_port2priority
  name                        = "nsr-${uuid()}"
  priority                    = each.value
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.key
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.example.name
}


resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id = var.subnet_id
  network_security_group_id = azurerm_network_security_group.example.id
}

output "nsg_id" {
  value = azurerm_network_security_group.example.id
}