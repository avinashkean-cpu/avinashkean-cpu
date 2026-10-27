variable "policy_enforcement_mode" {
  type        = string
  description = "Policy effect for missing tags: Deny or Audit"
  default     = "Deny"
}

variable "subscription_scope" {
  type        = string
  description = "Target Azure Subscription ID or Management Group ID for assignment"
  default     = ""
}

