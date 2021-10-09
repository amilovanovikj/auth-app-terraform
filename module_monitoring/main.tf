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