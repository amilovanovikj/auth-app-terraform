data azurerm_resource_group "shared" {
  name = "auth-shared-rg"
}

data "azurerm_container_registry" "acr" {
  name                = "azweacr01auth"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_route_table" "vnet_rt" {
  name                = "azwe-rt-01-auth"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_private_dns_zone" "database" {
  name                = "privatelink.mariadb.database.azure.com"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_private_dns_zone" "vaultcore" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = data.azurerm_resource_group.shared.name
}

data "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = data.azurerm_resource_group.shared.name
}
