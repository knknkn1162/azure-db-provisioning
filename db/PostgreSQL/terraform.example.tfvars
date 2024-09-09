subscription_id="***"
rg_location="japaneast"
vnet_cidr="10.0.0.0/16"
db_cidr="10.0.0.0/24"
# az postgres flexible-server list-skus -l {rg_location} -o table
db_spec="Standard_D4s_v3"
db_password = "***"
db_version = "11"
db_size_mb=640000
db_name="mydb"
client_vm_spec="Standard_B2s"