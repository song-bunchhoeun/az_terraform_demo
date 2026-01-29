## Commands

#### I. Get in Azure CLI console
az login

#### II. Check Subscription Acc/ID & Input if not yet fill in a value
az account show <br>
az account list --output table <br>
az account set --subscription "<SUBSCRIPTION_ID>"

#### III. Verify the Result
az group list --output table  =>(view resource groups) <br>
az webapp list --output table =>(view webapp service) <br>
az functionapp list --output table =>(view function service) <br>
az network vnet list --output table <br>
az storage account list --output table

#### IV. Az CLI deletion
az group delete --name rg-demo-terraform --yes => (delete az resource group)

#### VI. Terraform Execute/Deploy Command
terraform init => "initiation the resources" <br>
terraform plan => "Check plan to deploy and how many plan you would to do" <br>
terrafrom apply => "Execute process"
