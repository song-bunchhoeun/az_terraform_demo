# ============================================================================
# Backend Configuration - UAT Environment
# ============================================================================
# 
# State is stored in Azure Storage Account for:
# - Remote state management
# - State locking
# - Team collaboration
# - State encryption
#
# Initialize with:
#   terraform init -backend-config=../../backend_config/uat.hcl
#
# Or using Makefile:
#   make init
# ============================================================================

terraform {
  backend "azurerm" {
    # Configuration is provided via backend_config/uat.hcl
    # This keeps sensitive information out of version control
    #
    # Expected values:
    # - resource_group_name  = "tfstate-rg"
    # - storage_account_name = "ekycnoneprod7a8b"
    # - container_name       = "ekycnoneprod1a2b"
    # - key                  = "ekyc.uat.tfstate"
  }
}
