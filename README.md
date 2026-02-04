# Implementation create resources on Azure with Terraform
---
## I. Azure Infrastructure Provisioning with Terraform

This project uses **Terraform** to create and manage Azure resources such as:
- Resource Groups
- Virtual Networks & Subnets
- Azure Front Door
- WAF Policy
- Front Door Origin Groups & Routes
- API Management & API Management APIs
- App Service Plans
- App Services (Webapp, Functionapp)
- Storage Accounts
- Azure SQL Server & Private Endpoints
- Azure Redis (with Private Endpoint)
- Private DNS Zones

## II. Project Infrastructure
```
.
├── main.tf          # Main resource definitions
├── outputs.tf       # Output values
├── providers.tf      # Azure provider configuration
└── README.md
```
## III. Azure Authentication
```
az login
az account list --output table
az account set --subscription "<SUBSCRIPTION_ID>"
az account show
```

## IV. Terraform Commands
### 1. Initializ Terraform
#### Downloads provider plugins and initializes the working directory.
```
terraform init
```
### 2. Validate Configuration
#### Checks syntax and configuration correctness.
```
terraform validate
```
#### 3. Review Execution Plan
#### Shows what resources Terraform will create, update, or delete.
```
terraform plan
```
#### 4. Apply Changes
#### Creates or updates Azure resources.
```
terraform apply
terraform apply -auto-approve       ##Note : It won't query or ask you on confirmation step.
```
