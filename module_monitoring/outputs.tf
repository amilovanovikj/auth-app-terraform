output "instrumentation_key" {
  value = azurerm_application_insights.webapp.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value = azurerm_application_insights.webapp.connection_string
  sensitive = true
}