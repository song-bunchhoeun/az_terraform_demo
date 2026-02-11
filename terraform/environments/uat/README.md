# EKYC Infrastructure - DEV Environment

This directory contains the Terraform configuration for the **Development** environment using a modular approach.

## 📁 Structure

```
environments/dev/
├── main.tf           # Main configuration calling modules
├── variables.tf      # Variable declarations
├── outputs.tf        # Output definitions
├── providers.tf      # Provider and backend configuration
├── terraform.tfvars  # Variable values (gitignored)
├── Makefile          # Common operations
├── .gitignore        # Git ignore rules
└── README.md         # This file
```

## 🏗️ Modules Used

This environment uses the following reusable modules:

- **resource-group**: Use the existing one
- **identity**: Managed identity with federated credentials
- **database**: SQL Server with multiple databases
- **cache**: Redis Cache
- **compute**: App Service Plans, Web Apps, Functions, Static Web Apps

## 🚀 Quick Start

### 1. Set Up Variables

```bash
# Set SQL password (required)
export TF_VAR_sql_admin_password="YourSecurePassword123!"
```

### 2. Setup backend config
```bash
# copy the example config and change it
cd terraform/backend_config && cp dev.hcl.example uat.hcl
```

### 3. Initialize

```bash
make init
```

### 4. Deploy

```bash
make plan
make apply
```

## 📊 Resources Created

- 1 Managed Identity (with 2 federated credentials)
- 1 Application Insights
- 1 Storage Account
- 1 SQL Server (with 2 databases)
- 1 Redis Cache
- 3 App Service Plans
- 2 Web Apps (Linux API, Windows Portal)
- 1 Function App
- 1 Static Web App
- 1 API Management
- 1 Front Door (with 2 endpoints)

## 🔧 Common Operations

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

## 📝 Module Benefits

### Reusability
- Same modules used across dev, uat, and prod
- Consistent infrastructure across environments
- Easy to add new environments

### Maintainability
- Changes in one place affect all environments
- Clear separation of concerns
- Easier to test and validate

### Flexibility
- Environment-specific configurations
- Easy to override module defaults
- Scalable architecture

## 🔐 Security

- Sensitive variables marked as `sensitive = true`
- SQL password via environment variable
- State stored in Azure Storage with encryption
- HTTPS enforced on all web apps
- TLS 1.2 minimum

## 📚 More Information

- [Root README](../../README.md)
- [Module Documentation](../../modules/)
- [Migration Guide](../../MIGRATION_GUIDE.md)

## 🆘 Troubleshooting

### Module Not Found
```bash
# Reinitialize to download modules
make init
```

### State Lock
```bash
# Force unlock if needed
make unlock LOCK_ID=<id>
```

### Provider Issues
```bash
# Upgrade providers
make init-upgrade
```

## 📞 Support

For issues or questions:
- Check module documentation
- Review root README
- Contact infrastructure team
