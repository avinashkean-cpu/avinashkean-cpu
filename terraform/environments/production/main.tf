/**
 * Production Root Environment Deployment
 * Integrates Networking, Governance, Security, and AKS Modules
 * Author: Avinash Mishra
 */

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }

  backend "azurerm" {
    # Populated dynamically via CI/CD
    # resource_group_name  = "rg-terraform-state-prod"
    # storage_account_name = "sttfstateprod001"
    # container_name       = "tfstate"
    # key                  = "production.enterprise.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

module "networking" {
  source              = "../../modules/networking"
  prefix              = "prod-core"
  location            = "eastus2"
  resource_group_name = "rg-networking-hub-prod"
  hub_vnet_cidr       = "10.100.0.0/24"
}

module "governance" {
  source                   = "../../modules/governance-policy"
  policy_enforcement_mode  = "Deny"
}

