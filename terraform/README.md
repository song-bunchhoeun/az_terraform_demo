# EKYC Terraform Infrastructure

## 🏗️ New Modular Structure

```
terraform/
├── modules/              # ✨ Reusable modules
│   ├── resource-group/
│   ├── identity/
│   ├── monitoring/
│   ├── database/
│   ├── cache/
│   └── compute/
│
├── environments/         # ✨ Environment configs
│   ├── dev/             # Development
│   ├── uat/             # UAT
│   └── prod/            # Production
│
└── backend_config/       # State storage configs
```

## 🚀 Quick Start

### Deploy to Development

```bash
# 1. Navigate to dev environment
cd environments/dev

# 2. Set SQL password
export TF_VAR_sql_admin_password="YourSecurePassword123!"

# 3. Deploy
make init && make plan && make apply
```

### Deploy to UAT or Production

```bash
# For UAT
cd environments/uat

# For Production
cd environments/prod

# Then follow same steps as dev
export TF_VAR_sql_admin_password="YourSecurePassword123!"
make init && make plan && make apply
```

## 📖 Complete Documentation

### Getting Started
- **[FINAL_SUMMARY.md](FINAL_SUMMARY.md)** - What was built and why
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick commands
- **[INDEX.md](INDEX.md)** - Documentation index

### Architecture
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Visual architecture diagrams
- **[README_MODULAR.md](README_MODULAR.md)** - Modular architecture guide (300+ lines)
- **[MODULAR_STRUCTURE_SUMMARY.md](MODULAR_STRUCTURE_SUMMARY.md)** - Structure summary

### Migration
- **[MODULAR_MIGRATION.md](MODULAR_MIGRATION.md)** - Migration from old structure (400+ lines)
- **[MIGRATION_GUIDE.md](MIGRATION_GUIDE.md)** - Bicep to Terraform migration
- **[CHANGES.md](CHANGES.md)** - Detailed change log

### Implementation
- **[modules/README.md](modules/README.md)** - Module documentation
- **[environments/dev/README.md](environments/dev/README.md)** - Dev environment
- **[environments/uat/README.md](environments/uat/README.md)** - UAT environment
- **[environments/prod/README.md](environments/prod/README.md)** - Prod environment

## 🎯 Key Benefits

### Modular Architecture
- ✅ **47% less code** - Reduced from 1,500+ to ~800 lines
- ✅ **No duplication** - Shared modules across environments
- ✅ **Consistent** - Same patterns everywhere
- ✅ **Maintainable** - Update once, apply everywhere
- ✅ **Scalable** - Easy to add environments

### Infrastructure Coverage
All resources from Bicep template:
- ✅ Resource Groups
- ✅ Managed Identities (with federated credentials)
- ✅ SQL Server (with 2 databases)
- ✅ Redis Cache
- ✅ App Service Plans (3 types)
- ✅ Web Apps (Linux & Windows)
- ✅ Function Apps
- ✅ Static Web Apps
- ✅ API Management
- ✅ Azure Front Door (CDN)

### Best Practices
- ✅ Azure CAF naming conventions
- ✅ Consistent tagging strategy
- ✅ Secure secrets management
- ✅ State management in Azure Storage
- ✅ HTTPS-only enforcement
- ✅ TLS 1.2 minimum

## 📊 Modules

| Module | Purpose | Resources | Status |
|--------|---------|-----------|--------|
| **resource-group** | Resource group | 1 RG | ✅ Active |
| **identity** | Managed identity | 1 Identity + Credentials | ✅ Active |
| **monitoring** | Logging | Log Analytics + App Insights | ⚠️ Available (not deployed) |
| **database** | SQL Server | 1 Server + N Databases | ✅ Active |
| **cache** | Redis | 1 Redis Cache | ✅ Active |
| **compute** | App Services | Plans + Web Apps + Functions | ✅ Active |

## 🌍 Environments

| Environment | Path | State File | Purpose |
|-------------|------|------------|---------|
| **DEV** | `environments/dev/` | `ekyc.dev.tfstate` | Development |
| **UAT** | `environments/uat/` | `ekyc.uat.tfstate` | Testing |
| **PROD** | `environments/prod/` | `ekyc.prod.tfstate` | Production |

## 🛠️ Common Commands

```bash
# Show all commands
make help

# Initialize
make init

# Plan changes
make plan

# Apply changes
make apply

# Show outputs
make output

# Destroy (with confirmation)
make destroy
```

## 🔐 Security

- Sensitive variables marked as `sensitive = true`
- SQL password via environment variable
- State stored in Azure Storage with encryption
- HTTPS enforced on all web apps
- TLS 1.2 minimum
- Managed identities for CI/CD

## 📚 Learning Path

1. **Day 1**: Read [FINAL_SUMMARY.md](FINAL_SUMMARY.md)
2. **Day 2**: Review [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
3. **Day 3**: Deploy to dev
4. **Day 4**: Read [README_MODULAR.md](README_MODULAR.md)
5. **Day 5**: Deploy to uat/prod

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| Module not found | `make init` |
| State locked | `make unlock LOCK_ID=<id>` |
| Provider issues | `make init-upgrade` |
| Validation errors | `make validate && make fmt` |

See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for more troubleshooting.

## 📞 Support

1. Check [INDEX.md](INDEX.md) for documentation
2. Review [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
3. Read environment-specific README
4. Contact infrastructure team

## ⚠️ Important Notes

1. **Always test in dev first** before uat/prod
2. **SQL password** via environment variable only
3. **State files** contain sensitive data
4. **Module changes** affect all environments
5. **Review plans** carefully before applying

## 🎉 What's New

This infrastructure now features:

✅ Modular, reusable architecture  
✅ 47% code reduction  
✅ Consistent across environments  
✅ Easy to maintain and scale  
✅ Comprehensive documentation (3,600+ lines)  
✅ Production-ready  

See [FINAL_SUMMARY.md](FINAL_SUMMARY.md) for complete details.

---

**Quick Start**: `cd environments/dev && export TF_VAR_sql_admin_password="..." && make init && make apply`

**Documentation**: Start with [INDEX.md](INDEX.md) or [FINAL_SUMMARY.md](FINAL_SUMMARY.md)

## 📁 Directory Structure

```
Terraform/
├── README.md                # This file
├── MIGRATION_GUIDE.md       # Bicep to Terraform migration guide
├── backend_config/          # Backend configuration files per environment
│   ├── dev.hcl
│   ├── uat.hcl
│   └── prod.hcl
└── terraform_env/           # Environment-specific configurations
    ├── dev/                 # ✅ Development environment (UPDATED)
    │   ├── main.tf          # Main resource definitions
    │   ├── variables.tf     # Variable declarations
    │   ├── outputs.tf       # Output definitions
    │   ├── providers.tf     # Provider configuration
    │   ├── backend.tf       # State backend configuration
    │   ├── terraform.tfvars # Variable values (gitignored)
    │   ├── Makefile         # Common operations
    │   └── README.md        # Environment documentation
    ├── uat/                 # UAT environment (to be created)
    └── prod/                # Production environment (to be created)
```

## 🏗️ Infrastructure Overview

This Terraform configuration manages the following Azure resources:

### Compute Resources
- **App Service Plans**: 3 plans (Windows Portal, Linux API, Consumption Functions)
- **Linux Web Apps**: API application (DEV)
- **Windows Web Apps**: Portal application (DEV)
- **Function Apps**: Serverless functions
- **Static Web Apps**: Client portal

### Data & Storage
- **Azure SQL Server**: With 2 databases (operational, transaction)
- **Redis Cache**: Basic tier for caching
- **Storage Accounts**: For Function App

### Networking & CDN
- **Azure Front Door**: CDN with 2 endpoints (API, Portal)
- **API Management**: Developer tier with APIs and backends

### Security & Identity
- **Managed Identity**: For GitHub Actions federated authentication
- **Federated Identity Credentials**: For CI/CD pipelines



## 🚀 Quick Start

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) >= 2.40.0
- Azure subscription with appropriate permissions

### Getting Started

1. **Authenticate to Azure**
   ```bash
   az login
   az account list --output table
   az account set --subscription "<SUBSCRIPTION_ID>"
   az account show
   ```

2. **Navigate to environment directory**
   ```bash
   cd terraform_env/dev
   ```

3. **Configure variables**
   ```bash
   # Copy example file
   cp terraform.tfvars.example terraform.tfvars
   
   # Edit with your values
   nano terraform.tfvars
   ```

4. **Set sensitive variables**
   ```bash
   # Set SQL password via environment variable
   export TF_VAR_sql_admin_password="YourSecurePassword123!"
   ```

5. **Initialize Terraform**
   ```bash
   # Using Makefile (recommended)
   make init
   
   # Or using Terraform CLI
   terraform init
   ```

6. **Plan and Apply**
   ```bash
   # Using Makefile
   make plan
   make apply
   
   # Or using Terraform CLI
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

For detailed instructions, see the [Dev Environment README](terraform_env/dev/README.md).

## 📖 Documentation

- **[Migration Guide](MIGRATION_GUIDE.md)**: Complete guide for migrating from Bicep to Terraform
- **[Dev Environment README](terraform_env/dev/README.md)**: Detailed documentation for the development environment
- **[Backend Configuration](backend_config/)**: Backend state storage configuration

## 🛠️ Common Operations

### Using Makefile (Recommended)

The Makefile provides convenient shortcuts for common operations:

```bash
# Show all available commands
make help

# Initialize Terraform
make init

# Validate and format code
make check

# Create execution plan
make plan

# Apply changes
make apply

# Show outputs
make output

# Destroy resources (with confirmation)
make destroy
```

### Using Terraform CLI

```bash
# Initialize
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Show outputs
terraform output

# Destroy resources
terraform destroy
```

## 📊 Resource Naming Convention

Resources follow Azure CAF (Cloud Adoption Framework) naming standards:

```
{resource-type}-{project}-{environment}-{region}-{instance}
```

**Examples:**
- `rg-ekyc-nonprod-sea-001` (Resource Group)
- `app-ekyc-api-dev-sea-001` (Web App)
- `sql-ekyc-dev-sea-001` (SQL Server)
- `apim-ekyc-nonprod-sea-001` (API Management)

## 🏷️ Tagging Strategy

All resources are tagged with:
- **Environment**: nonprod/prod
- **Project**: ekyc
- **ManagedBy**: Terraform
- **CostCenter**: DGC

## 🔐 Security Best Practices

1. **Never commit sensitive data** to version control
2. Use **environment variables** for secrets in development
3. Use **Azure Key Vault** for production secrets
4. Enable **diagnostic logging** for all resources
5. Use **Managed Identities** where possible
6. Follow **principle of least privilege**
7. Enable **HTTPS only** for all web apps
8. Use **TLS 1.2** minimum

## 🔄 State Management

Terraform state is stored in Azure Storage:

- **Resource Group**: `tfstate-rg`
- **Storage Account**: `ekycnoneprod7a8b`
- **Container**: `ekycnoneprod1a2b`
- **State File**: `ekyc.{environment}.tfstate`

State locking is enabled to prevent concurrent modifications.

## 🔍 Troubleshooting

### State Lock Issues
```bash
# Force unlock (use carefully)
terraform force-unlock <lock-id>
# Or using Makefile
make unlock LOCK_ID=<lock-id>
```

### Provider Version Issues
```bash
# Upgrade providers
terraform init -upgrade
# Or using Makefile
make init-upgrade
```

### Validation Errors
```bash
# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Or using Makefile
make check
```

## 📝 Contributing

1. Create a feature branch
2. Make your changes
3. Run `make check` to validate and format
4. Test in development environment
5. Create a pull request
6. Wait for review and approval

## 📚 Additional Resources

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Naming Conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Azure CAF Terraform Modules](https://github.com/Azure/terraform-azurerm-caf)

## ⚠️ Important Notes

1. **State File**: Contains sensitive information - never commit to version control
2. **Passwords**: Always use secure methods (Key Vault, environment variables)
3. **Cost Management**: Monitor Azure costs regularly (API Management and Front Door can be expensive)
4. **Backup**: Ensure regular backups of databases and state files
5. **Testing**: Always test in non-production environments first
6. **Review**: Regular security and cost reviews

## 🆕 What's New

This Terraform configuration has been completely rewritten to:

✅ Match all resources from the Bicep template  
✅ Follow Terraform and Azure best practices  
✅ Include comprehensive documentation  
✅ Add Makefile for common operations  
✅ Implement proper security controls  
✅ Use consistent naming conventions  
✅ Include detailed outputs  
✅ Add migration guide from Bicep  

See [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md) for details on the migration from Bicep.

## 📞 Support

For issues or questions:
- Check the [Dev Environment README](terraform_env/dev/README.md)
- Review the [Migration Guide](MIGRATION_GUIDE.md)
- Check Terraform documentation
- Contact the infrastructure team
- Create an issue in the repository
