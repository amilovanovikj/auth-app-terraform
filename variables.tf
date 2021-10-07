variable env_name {
  type        = string
  default     = "dev"
  description = "Which environment to provision?"

  validation {
    condition     = var.env_name == "dev" || var.env_name == "test" || var.env_name == "prod"
    error_message = "The env_name variable can have one of the following values: dev, test, prod."
  }
}

variable sql_login {
  type        = string
  description = "Specify the SQL sysadmin username for MariaDB"
}

variable sql_password {
  type        = string
  sensitive   = true
  description = "Specify the SQL sysadmin password for MariaDB"
}

variable vault_pass {
  type        = string
  sensitive   = true
  description = "Specify the Ansible Vault password"
}

locals {  
  env = {
    dev = {
      env_char           = "d"
      node_env           = "development"
      vnet               = "${local.project_name}-test-dev-vnet"
      subnet             = "${local.project_name}-${var.env_name}-subnet"
      subnet_cidr        = "172.16.30.0/27"
      webapp_subnet_cidr = "172.16.30.80/28"
    }
    test = {
      env_char           = "t"
      node_env           = "testing"
      vnet               = "${local.project_name}-test-dev-vnet"
      subnet             = "${local.project_name}-${var.env_name}-subnet"
      subnet_cidr        = "172.16.30.32/27"
      webapp_subnet_cidr = "172.16.30.96/28"
    }
    prod = {
      env_char           = "p"
      node_env           = "production"
      vnet               = "${local.project_name}-prod-vnet"
      subnet             = "${local.project_name}-${var.env_name}-subnet"
      subnet_cidr        = "172.16.31.0/27"
      webapp_subnet_cidr = "172.16.31.48/28"
    }
  }

  project_name = "auth"
  env_num      = "01"
  prefix       = "azwe"

  variables = {
    
    rg = {
      name     = "${local.project_name}-${var.env_name}-${local.env_num}-rg"
      env_name = var.env_name
      location = "westeurope"
    }

    kv = {
      name         = "${local.project_name}-key-vault-${local.env["${var.env_name}"].env_char}${local.env_num}"
      secrets_path = "secrets-${var.env_name}.json"
      admin_id     = "d87677e2-9a1e-4a6f-b9fb-a45eb03975ad"
      dns_zone     = data.azurerm_private_dns_zone.vaultcore.id
    }

    sql = {
      name                  = "${local.prefix}-sql-${local.env["${var.env_name}"].env_char}${local.env_num}-${local.project_name}"
      db_name               = local.project_name
      sku                   = "GP_Gen5_2"
      size                  = 102400
      version               = "10.3"
      backup_retention_days = 7
      auto_grow             = false
      geo_redundancy        = false
      public_access         = false
      ssl_enabled           = true
      db_charset            = "utf8"
      db_collation          = "utf8_general_ci"
      dns_zone              = data.azurerm_private_dns_zone.database.id
    }

    cache = {
      name         = "${local.prefix}-sessionstore-${local.env["${var.env_name}"].env_char}${local.env_num}-${local.project_name}"
      capacity     = 0
      family       = "C"
      sku          = "Standard"
      non_ssl_port = false
      tls_version  = "1.2"
      dns_zone     = data.azurerm_private_dns_zone.redis.id
    }

    acr = {
      name = data.azurerm_container_registry.acr.name
      id   = data.azurerm_container_registry.acr.id
      rg   = data.azurerm_container_registry.acr.resource_group_name
    }

    asp = {
      name        = "${local.prefix}-asp-${local.env["${var.env_name}"].env_char}${local.env_num}-${local.project_name}"
      tier        = "Standard"
      size        = "S1"
      vnet_rg     = data.azurerm_resource_group.shared.name
      vnet        = "${local.env["${var.env_name}"].vnet}"
      subnet      = "${local.project_name}-${var.env_name}-webapp-subnet"
      subnet_cidr = local.env["${var.env_name}"].webapp_subnet_cidr
      route_table = data.azurerm_route_table.vnet_rt.id
      node_env    = local.env["${var.env_name}"].node_env
    }

    backend = {
      name     = "${local.prefix}-backend-${local.env["${var.env_name}"].env_char}${local.env_num}-${local.project_name}"
      app_name = "${local.project_name}-app-backend"
    }

    frontend = {
      name     = "${local.prefix}-frontend-${local.env["${var.env_name}"].env_char}${local.env_num}-${local.project_name}"
      app_name = "${local.project_name}-app-frontend"
    }

  }
}