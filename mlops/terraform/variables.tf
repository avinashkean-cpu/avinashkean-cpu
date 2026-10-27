variable "prefix" {
  type        = string
  default     = "enterprise"
}

variable "location" {
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-enterprise-mlops-prod"
}

variable "storage_account_name" {
  type        = string
  default     = "samlopsprod001data"
}

variable "key_vault_name" {
  type        = string
  default     = "kv-enterprise-mlops-01"
}

variable "container_registry_name" {
  type        = string
  default     = "acrenterpriseprodml01"
}

variable "tags" {
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Tier        = "MLOps-Platform"
    CostCenter  = "DataScience-4001"
  }
}

