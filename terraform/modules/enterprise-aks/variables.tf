variable "location" {
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-enterprise-aks-prod"
}

variable "cluster_name" {
  type        = string
  default     = "aks-enterprise-core-prod"
}

variable "system_node_count" {
  type        = number
  default     = 3
}

variable "aks_subnet_id" {
  type        = string
  description = "Subnet ID in the Spoke VNet designated for AKS"
}

variable "tags" {
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Tier        = "ContainerPlatform"
  }
}

