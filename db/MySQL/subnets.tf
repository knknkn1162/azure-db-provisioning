module "subnets" {
  source = "../../lib/subnets"
  rg_name = module.resource_group.name
  vnet_name = module.vnetwork.name
  label2cidr = {
    "db" = var.db_cidr
  }
}

module "inbound_nsg" {
  source = "../../lib/inbound_nsg"
  rg_location = module.resource_group.location
  rg_name = module.resource_group.name
  subnet_id = module.subnets.ids["db"]
  dst_port2priority = {
    "3306" = 100
    "22" = 110
  }
}