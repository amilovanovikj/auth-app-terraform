variable env {
	type = map
}

locals {
  backend_app_settings = {
    WEBSITE_VNET_ROUTE_ALL                          = true
    DOCKER_REGISTRY_SERVER_URL                      = "https://${var.env.acr.name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME                 = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-be-username)"
    DOCKER_REGISTRY_SERVER_PASSWORD                 = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-be-password)"
    APPINSIGHTS_INSTRUMENTATIONKEY                  = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=appinsights-instrumentation-key)"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=appinsights-connection-string)"
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "disabled"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "disabled"
    APPLICATIONINSIGHTS_CONFIGURATION_CONTENT       = ""
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DiagnosticServices_EXTENSION_VERSION            = "disabled"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    
    PORT               = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=server-port)"
    REDIS_URL          = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=redis-url)"
    REDIS_KEY          = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=redis-key)"
    SESSION_SECRET     = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=session-secret)"
    TYPEORM_HOST       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-host)"
    TYPEORM_USERNAME   = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-username)"
    TYPEORM_PASSWORD   = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-password)"
    TYPEORM_DATABASE   = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-database)"
    TYPEORM_PORT       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-port)"
    TYPEORM_LOGGING    = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-logging)"
    TYPEORM_ENTITIES   = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-entities)"
    CERT_LOCATION      = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=cert-location)"
    TYPEORM_MIGRATIONS = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=typeorm-migrations)"
    CORS_ORIGIN        = "https://${var.env.frontend.name}.azurewebsites.net"
    NODE_ENV           = var.env.asp.node_env
  }

  frontend_app_settings = {
    WEBSITE_VNET_ROUTE_ALL                          = true
    DOCKER_REGISTRY_SERVER_URL                      = "https://${var.env.acr.name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME                 = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-fe-username)"
    DOCKER_REGISTRY_SERVER_PASSWORD                 = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-fe-password)"
    APPINSIGHTS_INSTRUMENTATIONKEY                  = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=appinsights-instrumentation-key)"
    APPLICATIONINSIGHTS_CONNECTION_STRING           = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=appinsights-connection-string)"
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    APPLICATIONINSIGHTS_CONFIGURATION_CONTENT       = ""
    ApplicationInsightsAgent_EXTENSION_VERSION      = "~3"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
  }
}