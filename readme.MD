# Get in Azure CLI console
az login

# Check Subscription Acc/ID & Input if not yet fill in a value
az account show
az account list --output table
az account set --subscription "<SUBSCRIPTION_ID>"

# Verify the Resul
az group list --output table  =>(view resource groups)
az webapp list --output table =>(view webapp service)
az functionapp list --output table =>(view function service)

# Az CLI deletion
az group delete --name rg-demo-terraform --yes => (delete az resource group)