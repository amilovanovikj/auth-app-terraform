terraform {
  required_providers {
    ansiblevault = {
      source  = "MeilleursAgents/ansiblevault"
      version = "~> 2.0"
      configuration_aliases = [ ansiblevault.secrets ]
    }
  }
}

data "azurerm_client_config" "current" {}

data "ansiblevault_path" "secrets" {
  path     = var.env.kv.secrets_path
  provider = ansiblevault.secrets
}