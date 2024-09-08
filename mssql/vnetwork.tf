module "vnetwork" {
    source = "../lib/virtual_network"
    rg_location = module.resource_group.location
    rg_name = module.resource_group.name
    cidr = var.vnet_cidr
}