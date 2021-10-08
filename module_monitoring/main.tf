resource "azurerm_log_analytics_workspace" "logs" {
  name                = var.env.monitoring.log_workspace_name
  location            = var.env.rg.location
  resource_group_name = var.env.rg.name
  sku                 = var.env.monitoring.log_workspace_sku
  retention_in_days   = var.env.monitoring.log_retention
}

resource "azurerm_application_insights" "webapp" {
  name                = var.env.monitoring.appinsights_name
  location            = var.env.rg.location
  resource_group_name = var.env.rg.name
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = var.env.monitoring.app_type
}
