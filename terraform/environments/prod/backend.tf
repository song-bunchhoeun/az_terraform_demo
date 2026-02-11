# ============================================================================
# Backend Configuration - PROD Environment
# ============================================================================
# 
# State is stored in Azure Storage Account for:
# - Remote state management
# - State locking
# - Team collaboration
# - State encryption
#
# Initialize with:
#   terraform init -backend-config=../../backend_config/prod.hcl
#
# Or using Makefile:
#   make init
# ============================================================================

terraform {
  backend "azurerm" {
    # Configuration is provided via backend_config/prod.hcl
    # This keeps sensitive information out of version control
    #
    # Expected values:
    # - resource_group_name  = "tfstate-rg"
    # - storage_account_name = "ekycprod7a8b"
    # - container_name       = "ekycprod1a2b"
    # - key                  = "ekyc.prod.tfstate"
  }
}
