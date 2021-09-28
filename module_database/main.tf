resource "azurerm_mariadb_server" "sql" {
  name                = var.env.sql.name
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location

  administrator_login          = var.sql_login
  administrator_login_password = var.sql_password

  sku_name   = var.env.sql.sku
  storage_mb = var.env.sql.size
  version    = var.env.sql.version

  auto_grow_enabled             = var.env.sql.auto_grow
  backup_retention_days         = var.env.sql.backup_retention_days
  geo_redundant_backup_enabled  = var.env.sql.geo_redundancy
  public_network_access_enabled = var.env.sql.public_access
  ssl_enforcement_enabled       = var.env.sql.ssl_enabled
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${azurerm_mariadb_server.sql.name}-pe"
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                    = "privatelink.mariadb.database.azure.com"
    private_dns_zone_ids    = [ var.env.sql.dns_zone ]
  }
  private_service_connection {
    name                           = azurerm_mariadb_server.sql.name
    private_connection_resource_id = azurerm_mariadb_server.sql.id
    is_manual_connection           = false
    subresource_names              = ["mariadbServer"]
  }
}

resource "azurerm_mariadb_database" "db" {
  name                = var.env.sql.db_name
  resource_group_name = var.env.rg.name
  server_name         = azurerm_mariadb_server.sql.name
  charset             = var.env.sql.db_charset
  collation           = var.env.sql.db_collation
}

resource "azurerm_redis_cache" "redis" {
  name                          = var.env.cache.name
  resource_group_name           = var.env.rg.name
  location                      = var.env.rg.location
  capacity                      = var.env.cache.capacity
  family                        = var.env.cache.family
  sku_name                      = var.env.cache.sku
  enable_non_ssl_port           = var.env.cache.non_ssl_port
  minimum_tls_version           = var.env.cache.tls_version
  public_network_access_enabled = false

  redis_configuration {}
}

resource "azurerm_private_endpoint" "redis_pe" {
  name                = "${azurerm_redis_cache.redis.name}-pe"
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                    = "privatelink.redis.cache.windows.net"
    private_dns_zone_ids    = [ var.env.cache.dns_zone ]
  }
  private_service_connection {
    name                           = azurerm_redis_cache.redis.name
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }
}

output "redis_key" {
  value     = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}