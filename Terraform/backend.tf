terraform {
  backend "azurerm" {
    resource_group_name  = "TerraformStateRG"
    storage_account_name = "tfstateuniqueaccountname"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
