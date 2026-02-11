# ============================================================================
# CORE VARIABLES
# ============================================================================

variable "prefix" {
  description = "The prefix used for all resources (e.g., ekyc)"
  type        = string
  default     = "ekyc"
}

variable "location" {
  description = "The Azure Region where all resources should be created"
  type        = string
  default     = "Southeast Asia"
}

# ============================================================================
# TAGS
# ============================================================================

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project    = "ekyc"
    CostCenter = "DGC"
  }
}

# ============================================================================
# DATABASE
# ============================================================================

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
  default     = "ekycadmin"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

# ============================================================================
# API MANAGEMENT
# ============================================================================

variable "apim_publisher_name" {
  description = "API Management publisher name"
  type        = string
  default     = "Digital Government Committee"
}

variable "apim_publisher_email" {
  description = "API Management publisher email"
  type        = string
  default     = "devops@dgc.gov.kh"
}

# ============================================================================
# GITHUB INTEGRATION
# ============================================================================

variable "github_repo" {
  description = "GitHub repository for federated identity (format: org/repo)"
  type        = string
  default     = "SkailabCambodia/DGC.eKYC.Api"
}
