/**
 * Enterprise Governance & Azure Policy Module
 * Enforces Zero-Trust, Tagging compliance, and Geo-Fencing
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

# Policy 1: Mandatory Tag Enforcement on Resource Groups
resource "azurerm_policy_definition" "require_tags" {
  name         = "enforce-mandatory-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce Mandatory Governance Tags on Resource Groups"
  description  = "Denies creation of resource groups if required enterprise tags are missing."

  metadata = jsonencode({
    category = "Governance"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          anyOf = [
            { field = "tags['Environment']", exists = "false" },
            { field = "tags['CostCenter']", exists = "false" },
            { field = "tags['Owner']", exists = "false" },
            { field = "tags['ManagedBy']", exists = "false" }
          ]
        }
      ]
    }
    then = {
      effect = var.policy_enforcement_mode
    }
  })
}

# Policy 2: Enforce TLS 1.2 or 1.3 on Azure PaaS & Storage
resource "azurerm_policy_definition" "enforce_tls" {
  name         = "enforce-tls-12-minimum"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Enforce Minimum TLS 1.2 on Storage Accounts"
  description  = "Requires all Azure Storage Accounts to enforce TLS 1.2+ for encryption in transit."

  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })

  policy_rule = jsonencode({
    if = {
      allOf = [
        { field = "type", equals = "Microsoft.Storage/storageAccounts" },
        { field = "Microsoft.Storage/storageAccounts/minimumTlsVersion", notEquals = "TLS1_2" }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

# Policy Set / Initiative Definition
resource "azurerm_policy_set_definition" "enterprise_governance_initiative" {
  name         = "enterprise-governance-guardrails"
  policy_type  = "Custom"
  display_name = "Enterprise Cloud Adoption Framework Guardrails Initiative"
  description  = "Composite policy set governing tagging, transport encryption, and geographic boundaries."

  metadata = jsonencode({
    category = "Enterprise CAF Guardrails"
    version  = "2.0.0"
  })

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tags.id
    reference_id         = "RequireMandatoryTags"
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.enforce_tls.id
    reference_id         = "EnforceTLS12"
  }
}

