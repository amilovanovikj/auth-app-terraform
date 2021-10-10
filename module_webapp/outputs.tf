output "backend_mi" {
  value = azurerm_app_service.backend.identity.0.principal_id
}

output "frontend_mi" {
  value = azurerm_app_service.frontend.identity.0.principal_id
}

output "backend_id" {
  value = azurerm_app_service.backend.id
}

output "frontend_id" {
  value = azurerm_app_service.frontend.id
}

output "appservice_id" {
  value = azurerm_app_service_plan.asp.id
}

output "ip_addresses" {
  value = join(",", toset(concat(azurerm_app_service.backend.outbound_ip_address_list, azurerm_app_service.frontend.outbound_ip_address_list)))
}