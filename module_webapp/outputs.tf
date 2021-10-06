output "backend_id" {
  value = azurerm_app_service.backend.identity.0.principal_id
}

output "frontend_id" {
  value = azurerm_app_service.frontend.identity.0.principal_id
}

output "ip_addresses" {
  value = join(",", toset(concat(azurerm_app_service.backend.outbound_ip_address_list, azurerm_app_service.frontend.outbound_ip_address_list)))
}