variable "prefix" {
  type        = string
  description = "The prefix used for resource naming"
}

variable "location" {
  type        = string
  description = "The Azure region for deployment"
}
variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "A map of subnets to create"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  default = {
    "subnet1" = {
      name             = "subnet1"
      address_prefixes = ["10.0.1.0/24"]
    },
    "subnet2" = {
      name             = "subnet2"
      address_prefixes = ["10.0.2.0/24"]
    },
    "subnet3" = {
      name             = "subnet3"
      address_prefixes = ["10.0.3.0/24"]
    }
  }
}

variable "prefix" {
  description = "A prefix for all resource names"
  type        = string
}

variable "location" {
  description = "The Azure region for deployment"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}