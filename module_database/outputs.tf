output "redis_key" {
  value     = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}