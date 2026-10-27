/**
 * Enterprise Security & Zero-Trust Identity Module
 * Hardened Key Vault with Private Endpoint & Defender for Cloud
 * Author: Avinash Mishra (Principal Cloud & DevSecOps Enterprise Architect)
 */

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "sec_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hardened Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                          = var.key_vault_name
  location                      = azurerm_resource_group.sec_rg.location
  resource_group_name           = azurerm_resource_group.sec_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "premium"
  soft_delete_retention_days    = 90
  purge_protection_enabled      = true
  enable_rbac_authorization     = true
  public_network_access_enabled = false # Strict Zero-Trust (Private Endpoint only)

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  tags = var.tags
}

# Private Endpoint for Azure Key Vault
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "${var.key_vault_name}-private-endpoint"
  location            = azurerm_resource_group.sec_rg.location
  resource_group_name = azurerm_resource_group.sec_rg.name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Microsoft Defender for Cloud Enablement (Containers & VMs)
resource "azurerm_security_center_subscription_pricing" "defender_vms" {
  tier          = "Standard"
  resource_type = "VirtualMachines"
}

resource "azurerm_security_center_subscription_pricing" "defender_containers" {
  tier          = "Standard"
  resource_type = "Containers"
}

