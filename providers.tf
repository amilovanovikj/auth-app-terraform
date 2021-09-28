terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      version = ">= 2.75.0"
    }
    ansiblevault = {
    source  = "MeilleursAgents/ansiblevault"
    version = "~> 2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "auth-shared-rg"
    storage_account_name = "tfstate01auth"
    # container_name       = "tfstate-${env_char}${env_num}-auth"
    # key                  = "auth-${env}.tfstate"
  }
}

provider "azurerm" {
	features {}
  skip_provider_registration = true
  
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "ansiblevault" {
  alias = "secrets"
  vault_pass  = var.vault_pass
  root_folder = "${path.module}/module_keyvault/secrets/"
}