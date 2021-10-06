resource "azurerm_key_vault" "kv" {
  name                        = var.env.kv.name
  resource_group_name         = var.env.rg.name
  location                    = var.env.rg.location
  enabled_for_deployment      = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "None"
  }
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${azurerm_key_vault.kv.name}-pe"
  resource_group_name = var.env.rg.name
  location            = var.env.rg.location
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                    = "privatelink-vaultcore-azure-net"
    private_dns_zone_ids    = [ var.env.kv.dns_zone ]
  }
  private_service_connection {
    name                           = azurerm_key_vault.kv.name
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}

resource "azurerm_key_vault_access_policy" "admin" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.env.kv.admin_id

  key_permissions         = [ "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey","Update", "Verify", "WrapKey" ]
  secret_permissions      = [ "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set" ]
  certificate_permissions = [ "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "SetIssuers", "Update", "Backup", "Restore" ]
  storage_permissions     = [ "Backup", "Delete", "Deletesas", "Get", "GetSas", "list", "Listsas", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSas", "Update" ]
}

resource "azurerm_key_vault_access_policy" "spn" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [ "Get", "List", "Set", "Delete", "Purge" ]
}

resource "azurerm_key_vault_access_policy" "backend" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.backend_id

  secret_permissions = [
    "Get",
  ]
}


resource "azurerm_key_vault_access_policy" "frontend" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.frontend_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = jsondecode(data.ansiblevault_path.secrets.value)
  key_vault_id = azurerm_key_vault.kv.id
  name         = each.key
  value        = each.value

  depends_on = [
    azurerm_key_vault_access_policy.spn
  ]
}

resource "azurerm_key_vault_secret" "redis_key" {
  key_vault_id = azurerm_key_vault.kv.id
  name         = "redis-key"
  value        = var.redis_key

  depends_on = [
    azurerm_key_vault_access_policy.spn
  ]
}