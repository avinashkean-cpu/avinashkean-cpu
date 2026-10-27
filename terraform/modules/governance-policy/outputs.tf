output "initiative_id" {
  description = "The ID of the composite governance initiative"
  value       = azurerm_policy_set_definition.enterprise_governance_initiative.id
}

output "require_tags_policy_id" {
  description = "The policy definition ID for mandatory tagging"
  value       = azurerm_policy_definition.require_tags.id
}

output "enforce_tls_policy_id" {
  description = "The policy definition ID for TLS 1.2 minimum"
  value       = azurerm_policy_definition.enforce_tls.id
}

