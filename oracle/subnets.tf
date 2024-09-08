module "subnets" {
  source = "../lib/subnets"
  rg_name = module.resource_group.name
  vnet_name = module.vnetwork.name
  label2cidr = {
    "db" = var.db_cidr
  }
}