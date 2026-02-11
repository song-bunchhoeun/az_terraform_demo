variable "log_analytics_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "app_insights_name" {
  description = "Name of the Application Insights instance"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics"
  type        = string
  default     = "PerGB2018"
}

variable "application_type" {
  description = "Type of application"
  type        = string
  default     = "web"
}

variable "retention_in_days" {
  description = "Retention period in days"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
