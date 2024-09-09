subscription_id="***"
rg_location="japaneast"
vnet_cidr="10.0.0.0/16"
db_cidr="10.0.0.0/24"
# az postgres flexible-server list-skus -l {rg_location} -o table
db_spec="GP_Standard_D4s_v3"
db_password = "***"
db_version = "11"
# expected storage_mb to be one of [32768 65536 131072 262144 524288 1048576 2097152 4193280 4194304 8388608 16777216 33553408]
db_size_mb=524288
db_name="mydb"
client_vm_spec="Standard_B2s"