# ============================================================================
# CORE VARIABLES
# ============================================================================

variable "prefix" {
  description = "The prefix used for all resources (e.g., ekyc)"
  type        = string
  default     = "infra"
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
    Project    = "infra"
    CostCenter = "DEMO"
  }
}