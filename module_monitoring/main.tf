resource "azurerm_log_analytics_workspace" "logs" {
  name                = var.env.monitoring.log_workspace_name
  location            = var.env.rg.location
  resource_group_name = var.env.rg.name
  sku                 = var.env.monitoring.log_workspace_sku
  retention_in_days   = var.env.monitoring.log_retention
}

resource "azurerm_application_insights" "webapps" {
  name                = var.env.monitoring.appinsights_name
  location            = var.env.rg.location
  resource_group_name = var.env.rg.name
  workspace_id        = azurerm_log_analytics_workspace.logs.id
  application_type    = var.env.monitoring.app_type
}

resource "azurerm_monitor_metric_alert" "cpu_percentage" {
  name                = "web-apps-cpu-alert"
  resource_group_name = var.env.rg.name
  scopes              = [ var.appservice_id ]
  description         = "Alert will be triggered when CPU percentage is greater than 70."

  frequency   = "PT15M"
  window_size = "PT15M"
  severity    = 2

  criteria {
    metric_namespace = "Microsoft.Web/serverFarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 70
  }

  action {
    action_group_id = var.env.monitoring.email_action_group
  }
}

resource "azurerm_monitor_metric_alert" "backend_server_errors" {
  name                = "backend-server-errors"
  resource_group_name = var.env.rg.name
  scopes              = [ var.backend_id ]
  description         = "Alert will be triggered when server errors appear on the backend instance."

  frequency   = "PT5M"
  window_size = "PT5M"
  severity    = 1

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Count"
    operator         = "GreaterThanOrEqual"
    threshold        = 1
  }

  action {
    action_group_id = var.env.monitoring.email_action_group
  }
}

resource "azurerm_monitor_metric_alert" "frontend_server_errors" {
  name                = "frontend-server-errors"
  resource_group_name = var.env.rg.name
  scopes              = [ var.frontend_id ]
  description         = "Alert will be triggered when server errors appear on the frontend instance."

  frequency   = "PT5M"
  window_size = "PT5M"
  severity    = 1

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Count"
    operator         = "GreaterThanOrEqual"
    threshold        = 1
  }

  action {
    action_group_id = var.env.monitoring.email_action_group
  }
}

resource "azurerm_monitor_metric_alert" "backend_response_time" {
  name                = "backend-response-time-alert"
  resource_group_name = var.env.rg.name
  scopes              = [ var.backend_id ]
  description         = "Alert will be triggered when the backend instance has slow response time."

  frequency   = "PT30M"
  window_size = "PT30M"
  severity    = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = var.env.monitoring.email_action_group
  }
}

resource "azurerm_monitor_metric_alert" "frontend_response_time" {
  name                = "frontend-response-time-alert"
  resource_group_name = var.env.rg.name
  scopes              = [ var.frontend_id ]
  description         = "Alert will be triggered when the frontend instance has slow response time"

  frequency   = "PT30M"
  window_size = "PT30M"
  severity    = 3

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HttpResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = var.env.monitoring.email_action_group
  }
}

resource "azurerm_monitor_diagnostic_setting" "backend_diag" {
  name                       = "${var.env.backend.name}-diag"
  target_resource_id         = var.backend_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceAppLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServicePlatformLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "frontend_diag" {
  name                       = "${var.env.frontend.name}-diag"
  target_resource_id         = var.frontend_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceAppLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AppServicePlatformLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}