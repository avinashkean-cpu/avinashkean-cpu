variable "prefix" {
  type        = string
  description = "Resource prefix for naming conventions (e.g. corp-prod)"
  default     = "corp-hub"
}

variable "location" {
  type        = string
  description = "Azure primary region"
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group hosting the hub"
  default     = "rg-hub-networking-prod"
}

variable "hub_vnet_cidr" {
  type        = string
  description = "CIDR range for the Hub Virtual Network (must be at least /24)"
  default     = "10.100.0.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Resource governance tags"
  default = {
    Environment     = "Production"
    ManagedBy       = "Terraform"
    ArchitectureCAF = "Hub-and-Spoke"
    CostCenter      = "CloudPlatform-1001"
  }
}

