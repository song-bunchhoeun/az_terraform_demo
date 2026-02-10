# ============================================================================
# EKYC Infrastructure - UAT Environment
# ============================================================================

locals {
  environment = "demo"
  env_short   = "uat"
  location    = var.location
  prefix      = var.prefix

  common_tags = merge(var.common_tags, {
    Environment = local.environment
    ManagedBy   = "Terraform"
  })
}

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "rg-${local.prefix}-${local.environment}-01"
  location = var.location
  tags     = local.common_tags
}