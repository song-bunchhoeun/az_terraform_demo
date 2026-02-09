# Implementation create resources on Azure with variables.tfvars
---
## I. Azure Infrastructure Provisioning with variables.tfvars

This project uses **variables.tfvars** to create and manage Azure resources such as:
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
├── README.md
├── .gitignore
├── scripts/
│   └── gitpush.sh
│
├── backend-config/
│   ├── dev.hcl
│   ├── uat.hcl
│   └── prod.hcl
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── variables.tfvars
│   │
│   ├── uat/
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── variables.tfvars
│   │
│   └── prod/
│       ├── main.tf
│       ├── backend.tf
│       ├── providers.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── variables.tfvars

```
## III. Azure Authentication
```
az login
az account list --output table
az account set --subscription "<SUBSCRIPTION_ID>"
az account show
```

## IV. variables.tfvars Commands
### 1. Initializ variables.tfvars
#### Downloads provider plugins and initializes the working directory.
```
variables.tfvars init
```
### 2. Validate Configuration
#### Checks syntax and configuration correctness.
```
variables.tfvars validate
```
#### 3. Review Execution Plan
#### Shows what resources variables.tfvars will create, update, or delete.
```
variables.tfvars plan
```
#### 4. Apply Changes
#### Creates or updates Azure resources.
```
variables.tfvars apply
variables.tfvars apply -auto-approve       ##Note : It won't query or ask you on confirmation step.
```
