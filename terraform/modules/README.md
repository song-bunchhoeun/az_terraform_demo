# Terraform Modules

This directory contains reusable Terraform modules for the EKYC infrastructure.

## 📁 Available Modules

### 1. Resource Group (`resource-group/`)
Creates an Azure Resource Group.

**Usage**:
```hcl
module "rg" {
  source = "../../modules/resource-group"
  
  name     = "rg-ekyc-nonprod-sea-001"
  location = "Southeast Asia"
  tags     = { Environment = "nonprod" }
}
```

**Outputs**: `name`, `location`, `id`

---

### 2. Identity (`identity/`)
Creates a Managed Identity with optional Federated Identity Credentials for GitHub Actions.

**Usage**:
```hcl
module "identity" {
  source = "../../modules/identity"
  
  name                = "mi-github-ekyc-nonprod"
  location            = "Southeast Asia"
  resource_group_name = "rg-ekyc-nonprod-sea-001"
  
  federated_credentials = {
    "github-ekyc-dev" = {
      audience = ["api://AzureADTokenExchange"]
      issuer   = "https://token.actions.githubusercontent.com"
      subject  = "repo:SkailabCambodia/DGC.eKYC.Api:environment:dev"
    }
  }
  
  tags = { Environment = "nonprod" }
}
```

**Outputs**: `id`, `client_id`, `principal_id`, `name`

---

### 3. Monitoring (`monitoring/`)
Creates Log Analytics Workspace and Application Insights.

**Usage**:
```hcl
module "monitoring" {
  source = "../../modules/monitoring"
  
  log_analytics_name  = "log-ekyc-nonprod-sea-001"
  app_insights_name   = "app-ekyc-api-dev-sea-001"
  location            = "Southeast Asia"
  resource_group_name = "rg-ekyc-nonprod-sea-001"
  retention_in_days   = 90
  
  tags = { Environment = "nonprod" }
}
```

**Outputs**: `log_analytics_workspace_id`, `app_insights_id`, `app_insights_instrumentation_key`, `app_insights_connection_string`

---

### 4. Database (`database/`)
Creates SQL Server with multiple databases.

**Usage**:
```hcl
module "database" {
  source = "../../modules/database"
  
  server_name         = "sql-ekyc-dev-sea-001"
  resource_group_name = "rg-ekyc-nonprod-sea-001"
  location            = "Southeast Asia"
  admin_username      = "ekycadmin"
  admin_password      = var.sql_admin_password
  
  databases = {
    operational = {
      name           = "eKYCOperational"
      collation      = "SQL_Latin1_General_CP1_CI_AS"
      max_size_gb    = 2
      sku_name       = "Basic"
      zone_redundant = false
    }
    transaction = {
      name           = "eKYCTransaction"
      collation      = "SQL_Latin1_General_CP1_CI_AS"
      max_size_gb    = 2
      sku_name       = "Basic"
      zone_redundant = false
    }
  }
  
  tags = { Environment = "nonprod" }
}
```

**Outputs**: `server_id`, `server_name`, `server_fqdn`, `database_ids`, `database_names`

---

### 5. Cache (`cache/`)
Creates Redis Cache.

**Usage**:
```hcl
module "cache" {
  source = "../../modules/cache"
  
  name                = "redis-ekyc-nonprod-sea-001"
  location            = "Southeast Asia"
  resource_group_name = "rg-ekyc-nonprod-sea-001"
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  
  tags = { Environment = "nonprod" }
}
```

**Outputs**: `id`, `hostname`, `primary_access_key`, `primary_connection_string`

---

### 6. Compute (`compute/`)
Creates App Service Plans, Web Apps (Linux & Windows), Function Apps, and Static Web Apps.

**Usage**:
```hcl
module "compute" {
  source = "../../modules/compute"
  
  resource_group_name = "rg-ekyc-nonprod-sea-001"
  location            = "Southeast Asia"
  
  app_service_plans = {
    portal = {
      name     = "plan-ekyc-nonprod-sea-001"
      os_type  = "Windows"
      sku_name = "B1"
    }
    api = {
      name     = "plan-ekyc-nonprod-sea-002"
      os_type  = "Linux"
      sku_name = "B1"
    }
  }
  
  linux_web_apps = {
    api_dev = {
      name             = "app-ekyc-api-dev-sea-001"
      service_plan_key = "api"
      dotnet_version   = "8.0"
      always_on        = false
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "1"
      }
    }
  }
  
  windows_web_apps = {
    portal_dev = {
      name             = "app-ekyc-portal-dev-sea-001"
      service_plan_key = "portal"
      dotnet_version   = "v4.0"
      always_on        = false
      app_settings = {
        "WEBSITE_RUN_FROM_PACKAGE" = "1"
      }
    }
  }
  
  function_apps = {
    main = {
      name                       = "func-ekyc-dev-sea-001"
      service_plan_key           = "function"
      storage_account_name       = "stekycdev123456"
      storage_account_access_key = "..."
      dotnet_version             = "v8.0"
      app_settings = {
        "FUNCTIONS_EXTENSION_VERSION" = "~4"
      }
    }
  }
  
  static_web_apps = {
    client_portal = {
      name     = "ekyc-client-portal"
      location = "East Asia"
      sku_tier = "Free"
      sku_size = "Free"
    }
  }
  
  tags = { Environment = "nonprod" }
}
```

**Outputs**: `app_service_plan_ids`, `linux_web_app_ids`, `linux_web_app_hostnames`, `windows_web_app_ids`, `windows_web_app_hostnames`, `function_app_ids`, `function_app_hostnames`, `static_web_app_ids`, `static_web_app_hostnames`

---

## 🎯 Module Design Principles

### 1. Single Responsibility
Each module focuses on one logical grouping of resources.

### 2. Reusability
Modules can be used across multiple environments (dev, uat, prod).

### 3. Configurability
Modules accept variables for customization while providing sensible defaults.

### 4. Outputs
Modules expose useful outputs for use by other modules or root configuration.

### 5. Documentation
Each module includes clear documentation of inputs and outputs.

## 📝 Module Structure

Each module follows this structure:

```
module-name/
├── main.tf       # Resource definitions
├── variables.tf  # Input variables
├── outputs.tf    # Output values
└── README.md     # Documentation (optional)
```

## 🔧 Using Modules

### In Environment Configuration

```hcl
# environments/dev/main.tf

module "resource_group" {
  source = "../../modules/resource-group"
  
  name     = "rg-ekyc-nonprod-sea-001"
  location = "Southeast Asia"
  tags     = local.common_tags
}

module "database" {
  source = "../../modules/database"
  
  server_name         = "sql-ekyc-dev-sea-001"
  resource_group_name = module.resource_group.name  # Use output from another module
  location            = module.resource_group.location
  # ...
}
```

### Module Dependencies

Modules can depend on outputs from other modules:

```hcl
# Resource group module output
module "resource_group" {
  source = "../../modules/resource-group"
  # ...
}

# Database module uses resource group output
module "database" {
  source = "../../modules/database"
  
  resource_group_name = module.resource_group.name  # Dependency
  location            = module.resource_group.location
  # ...
}
```

## 🔐 Security Best Practices

### 1. Sensitive Variables
Mark sensitive variables appropriately:

```hcl
variable "admin_password" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}
```

### 2. Secure Defaults
Use secure defaults in modules:

```hcl
variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"  # Secure default
}
```

### 3. HTTPS Only
Enforce HTTPS in web apps:

```hcl
resource "azurerm_linux_web_app" "this" {
  # ...
  https_only = true
}
```

## 🧪 Testing Modules

### Test Individual Module

```bash
cd modules/resource-group

# Create test configuration
cat > test.tf <<EOF
module "test" {
  source = "./"
  
  name     = "test-rg"
  location = "Southeast Asia"
  tags     = { Test = "true" }
}
EOF

# Initialize and plan
terraform init
terraform plan
```

### Validate Module

```bash
cd modules/resource-group
terraform validate
terraform fmt -check
```

## 📊 Module Versioning

For production use, consider versioning modules:

```hcl
module "database" {
  source = "git::https://github.com/your-org/terraform-modules.git//database?ref=v1.0.0"
  # ...
}
```

## 🔄 Module Updates

### Update All Modules

```bash
cd environments/dev
terraform get -update
terraform init -upgrade
```

### Update Specific Module

```bash
# Edit module code
cd modules/database
# Make changes

# Update in environment
cd ../../environments/dev
terraform get -update
terraform plan
```

## 📚 Additional Resources

- [Terraform Module Documentation](https://www.terraform.io/docs/language/modules/index.html)
- [Module Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/part3.html)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## 🆘 Troubleshooting

### Module Not Found
```bash
terraform init
terraform get -update
```

### Module Changes Not Applied
```bash
terraform init -upgrade
```

### Circular Dependencies
Review module dependencies and use data sources instead of module outputs where possible.

## 📞 Support

For module-related questions:
- Review module code and documentation
- Check environment configuration
- Test module independently
- Contact infrastructure team

---

**Note**: These modules are designed specifically for the EKYC project but can be adapted for other projects with similar requirements.
