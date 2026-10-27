output "key_vault_id" {
  description = "Resource ID of the hardened Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "Vault URI for secret retrieval"
  value       = azurerm_key_vault.kv.vault_uri
}

output "private_endpoint_ip" {
  description = "Allocated Private IP of Key Vault Private Endpoint"
  value       = azurerm_private_endpoint.kv_pe.private_service_connection[0].private_ip_address
}

