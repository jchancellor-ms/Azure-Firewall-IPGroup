#read in the json template for ip_group_creation
locals {
  ip_group_definitions = jsondecode(file("${path.module}/${var.input_filename}"))
  relative_path        = path.module
}


#create the IP groups
module "create_ip_groups" {
  source = "./modules/azure_create_multiple_ip_groups_from_csv"

  ip_group_definitions = local.ip_group_definitions.ip_groups
}
