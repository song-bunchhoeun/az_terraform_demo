variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_service_plans" {
  description = "Map of App Service Plans to create"
  type = map(object({
    name     = string
    os_type  = string
    sku_name = string
  }))
  default = {}
}

variable "linux_web_apps" {
  description = "Map of Linux Web Apps to create"
  type = map(object({
    name                = string
    service_plan_key    = string
    dotnet_version      = string
    always_on           = bool
    app_settings        = map(string)
  }))
  default = {}
}

variable "windows_web_apps" {
  description = "Map of Windows Web Apps to create"
  type = map(object({
    name             = string
    service_plan_key = string
    dotnet_version   = string
    always_on        = bool
    app_settings     = map(string)
  }))
  default = {}
}

variable "function_apps" {
  description = "Map of Function Apps to create"
  type = map(object({
    name                       = string
    service_plan_key           = string
    storage_account_name       = string
    storage_account_access_key = string
    dotnet_version             = string
    app_settings               = map(string)
  }))
  default = {}
}

variable "static_web_apps" {
  description = "Map of Static Web Apps to create"
  type = map(object({
    name     = string
    location = string
    sku_tier = string
    sku_size = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
