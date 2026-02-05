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