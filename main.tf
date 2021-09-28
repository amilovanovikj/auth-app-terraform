module "webapp" {
  env           = local.variables
  source        = "./module_webapp"
}

module "keyvault" {
  env           = local.variables
  subnet_id     = azurerm_subnet.subnet.id
  backend_id    = module.webapp.backend_id
  frontend_id   = module.webapp.frontend_id
  redis_key     = module.database.redis_key
  source        = "./module_keyvault"
  
  providers = {
    ansiblevault.secrets = ansiblevault.secrets
  }
}

module "database" {
  env           = local.variables
  subnet_id     = azurerm_subnet.subnet.id
  sql_login     = var.sql_login
  sql_password  = var.sql_password
  source        = "./module_database"
}

resource "azurerm_subnet" "subnet" {
  name                 = local.env["${var.env_name}"].subnet
  resource_group_name  = data.azurerm_resource_group.shared.name
  virtual_network_name = local.env["${var.env_name}"].vnet
  address_prefixes     = [ local.env["${var.env_name}"].subnet_cidr ]
  
  enforce_private_link_endpoint_network_policies = true
}