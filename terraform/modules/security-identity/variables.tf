variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for security services"
  default     = "rg-enterprise-security-prod"
}

variable "key_vault_name" {
  type        = string
  description = "Globally unique name for Key Vault"
  default     = "kv-enterprise-core-sec"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID hosting the Private Endpoint"
}

variable "tags" {
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Tier        = "Security-ControlPlane"
  }
}

