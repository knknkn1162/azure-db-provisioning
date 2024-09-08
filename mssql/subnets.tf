module "subnets" {
  source = "../lib/subnets"
  rg_name = module.resource_group.name
  vnet_name = module.vnetwork.name
  label2cidr = {
    "db" = var.db_cidr
  }
  # Subnets of virtual network do have ServiceEndpoints for Microsoft.Sql resources configured.
  # Add Microsoft.Sql to subnet's ServiceEndpoints collection before trying to ACL Microsoft.Sql resources to these subnets
  service_endpoints = ["Microsoft.Sql"]
}