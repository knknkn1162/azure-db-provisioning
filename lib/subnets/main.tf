variable "rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "label2cidr" {
  type = map(string)
}

variable "service_endpoints" {
  type = list(string)
  default = []
}

# subnet resources must be created all at once
resource "azurerm_subnet" "example" {
  for_each = var.label2cidr
  name = (lower(each.key) == "bastion") ? "AzureBastionSubnet" : "subnet-${each.key}"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = [each.value]
  service_endpoints    = var.service_endpoints
}


output "ids" {
  value = {for key, val in azurerm_subnet.example: key => val.id}
}

output "names" {
  value = {for key, val in azurerm_subnet.example: key => val.name}
}