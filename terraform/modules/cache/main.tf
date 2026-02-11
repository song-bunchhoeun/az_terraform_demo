# ============================================================================
# Cache Module - Azure Managed Redis
# ============================================================================

resource "azurerm_managed_redis" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  default_database {
    access_keys_authentication_enabled = true
    client_protocol                    = "Encrypted"
    clustering_policy                  = "OSSCluster"
    eviction_policy                    = var.eviction_policy
  }

  tags = var.tags
}
