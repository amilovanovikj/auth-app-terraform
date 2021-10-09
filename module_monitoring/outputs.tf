output "instrumentation_key" {
  value = azurerm_application_insights.webapps.instrumentation_key
  sensitive = true
}

output "connection_string" {
  value = azurerm_application_insights.webapps.connection_string
  sensitive = true
}