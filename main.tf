module "webapp" {
  env        = local.variables
  source     = "./module_webapp"
  depends_on = [
    module.database
  ]
}

module "keyvault" {
  env         = local.variables
  subnet_id   = azurerm_subnet.subnet.id
  backend_id  = module.webapp.backend_mi
  frontend_id = module.webapp.frontend_mi
  source      = "./module_keyvault"
  
  redis_key                       = module.database.redis_key
  appinsights_instrumentation_key = module.monitoring.instrumentation_key
  appinsights_connection_string   = module.monitoring.connection_string

  providers = {
    ansiblevault.secrets = ansiblevault.secrets
  }
}

module "database" {
  env          = local.variables
  subnet_id    = azurerm_subnet.subnet.id
  sql_login    = var.sql_login
  sql_password = var.sql_password
  source       = "./module_database"
}

module "monitoring" {
  env           = local.variables
  backend_id    = module.webapp.backend_id
  frontend_id   = module.webapp.frontend_id
  appservice_id = module.webapp.appservice_id
  source        = "./module_monitoring"
}

resource "azurerm_subnet" "subnet" {
  name                 = local.env["${var.env_name}"].subnet
  resource_group_name  = data.azurerm_resource_group.shared.name
  virtual_network_name = local.env["${var.env_name}"].vnet
  address_prefixes     = [ local.env["${var.env_name}"].subnet_cidr ]
  
  enforce_private_link_endpoint_network_policies = true
}

output "webapp_ip_addresses" {
  value = module.webapp.ip_addresses
}

output "acr_name" {
  value = local.variables.acr.name
}

output "acr_rg" {
  value = local.variables.acr.rg
}