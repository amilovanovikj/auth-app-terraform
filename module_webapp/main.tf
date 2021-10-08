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
  app_settings        = var.env.backend.app_settings
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
}

resource "azurerm_app_service" "frontend" {
  name                = var.env.frontend.name
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id
  app_settings        = var.env.frontend.app_settings
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
