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
    container_name       = "tfstate-auth-container"
    # key                  = "auth-${env}.tfstate"
  }
}

provider "azurerm" {
	features {}
  skip_provider_registration = true
}

provider "ansiblevault" {
  alias = "secrets"
  vault_pass  = var.vault_pass
  root_folder = "${path.module}/module_keyvault/secrets/"
}