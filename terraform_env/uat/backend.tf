terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "ekycnoneprod7a8b"  ## Need change name based env (prod, uat, dev)
    container_name       = "ekycnoneprod1a2b"  ## Need change name based env (prod, uat, dev)
    key                  = "ekyc.uat.tfstate"  ## Key name based on your env (prod, uat, dev)
  }
}