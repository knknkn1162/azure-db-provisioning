subscription_id="***"
rg_location="japaneast"
vnet_cidr="10.0.0.0/16"
db_cidr="10.0.0.0/24"
# one of ["B_Gen4_1" "B_Gen4_2" "B_Gen5_1" "B_Gen5_2" "GP_Gen4_2" "GP_Gen4_4" "GP_Gen4_8" "GP_Gen4_16" "GP_Gen4_32" "GP_Gen5_2" "GP_Gen5_4" "GP_Gen5_8" "GP_Gen5_16" "GP_Gen5_32" "GP_Gen5_64" "MO_Gen5_2" "MO_Gen5_4" "MO_Gen5_8" "MO_Gen5_16" "MO_Gen5_32"]
db_spec="GP_Gen4_4"
db_password = "***"
db_version = "11"
db_size_mb=640000
db_name="mydb"
client_vm_spec="Standard_B2s"