variable "name" {
  description = "Name of the Managed Redis instance"
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

variable "sku_name" {
  description = "SKU name for Managed Redis (e.g., Balanced_B1, MemoryOptimized_M1, ComputeOptimized_X1)"
  type        = string
  default     = "Balanced_B1"
}

variable "eviction_policy" {
  description = "Redis eviction policy (AllKeysLFU, AllKeysLRU, AllKeysRandom, VolatileLRU, VolatileLFU, VolatileTTL, VolatileRandom, NoEviction)"
  type        = string
  default     = "VolatileLRU"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
