resource "azurerm_app_service_plan" "asp" {
  name                = var.env.asp.name
  resource_group_name = var.env.rg.name  
  location            = var.env.rg.location
  kind                = "Linux"
  reserved            = true

  sku {
    tier = var.env.asp.tier
    size = var.env.asp.size
  }
}

resource "azurerm_app_service" "backend" {
  name                = var.env.backend.name
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  enabled             = true
  https_only          = true
  
  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages_enabled = true 
    failed_request_tracing_enabled  = true 
    
    http_logs { 
      file_system {
        retention_in_mb   = 100
        retention_in_days = 0
      }
    }
  }

  site_config {
    linux_fx_version = "DOCKER|${var.env.acr.name}.azurecr.io/${var.env.backend.app_name}:latest"

    always_on     = true
    http2_enabled = true
    ftps_state    = "Disabled"
  }

  app_settings = {
    WEBSITE_VNET_ROUTE_ALL                = true
    APPINSIGHTS_INSTRUMENTATIONKEY        = var.appinsights_instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.appinsights_connection_string
    DOCKER_REGISTRY_SERVER_URL            = "https://${var.env.acr.name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-be-username)"
    DOCKER_REGISTRY_SERVER_PASSWORD       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-be-password)"
    
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
}

resource "azurerm_app_service" "frontend" {
  name                = var.env.frontend.name
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  enabled             = true
  https_only          = true
  
  identity {
    type = "SystemAssigned"
  }

  logs {
    detailed_error_messages_enabled = true 
    failed_request_tracing_enabled  = true 
    
    http_logs { 
      file_system {
        retention_in_mb   = 100
        retention_in_days = 0
      }
    }
  }

  site_config {
    linux_fx_version = "DOCKER|${var.env.acr.name}.azurecr.io/${var.env.frontend.app_name}:${var.env.rg.env_name}-latest"

    always_on     = true
    http2_enabled = true
    ftps_state    = "Disabled"
  }

  app_settings = {
    WEBSITE_VNET_ROUTE_ALL                = true
    APPINSIGHTS_INSTRUMENTATIONKEY        = var.appinsights_instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = var.appinsights_connection_string
    DOCKER_REGISTRY_SERVER_URL            = "https://${var.env.acr.name}.azurecr.io"
    DOCKER_REGISTRY_SERVER_USERNAME       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-fe-username)"
    DOCKER_REGISTRY_SERVER_PASSWORD       = "@Microsoft.KeyVault(VaultName=${var.env.kv.name};SecretName=acr-fe-password)"
  }
}

resource "azurerm_subnet" "webapp" {
  name                 = var.env.asp.subnet
  resource_group_name  = var.env.asp.vnet_rg
  virtual_network_name = var.env.asp.vnet
  address_prefixes     = [ var.env.asp.subnet_cidr ]

  delegation {
    name = "webapp"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_backend" {
  app_service_id = azurerm_app_service.backend.id
  subnet_id      = azurerm_subnet.webapp.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "vnet_frontend" {
  app_service_id = azurerm_app_service.frontend.id
  subnet_id      = azurerm_subnet.webapp.id
}

resource "azurerm_subnet_route_table_association" "vnet_route" {
  subnet_id      = azurerm_subnet.webapp.id
  route_table_id = var.env.asp.route_table
}
