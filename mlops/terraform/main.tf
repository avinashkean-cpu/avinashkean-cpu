/**
 * Enterprise MLOps Infrastructure Module
 * Provisions Azure Machine Learning Workspace with hardened dependencies
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

resource "azurerm_resource_group" "ml_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 1. Dedicated Storage Account for Datasets & Artifacts
resource "azurerm_storage_account" "ml_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.ml_rg.name
  location                 = azurerm_resource_group.ml_rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

# 2. Key Vault for Model Secrets & Data Connection Strings
resource "azurerm_key_vault" "ml_kv" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.ml_rg.location
  resource_group_name = azurerm_resource_group.ml_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = var.tags
}

data "azurerm_client_config" "current" {}

# 3. Application Insights for Inference Model Telemetry
resource "azurerm_application_insights" "ml_ai" {
  name                = "${var.prefix}-ml-appinsights"
  location            = azurerm_resource_group.ml_rg.location
  resource_group_name = azurerm_resource_group.ml_rg.name
  application_type    = "web"
  tags                = var.tags
}

# 4. Azure Container Registry for Model Scoring Docker Images
resource "azurerm_container_registry" "ml_acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.ml_rg.name
  location            = azurerm_resource_group.ml_rg.location
  sku                 = "Premium"
  admin_enabled       = false
  tags                = var.tags
}

# 5. Azure Machine Learning Workspace
resource "azurerm_machine_learning_workspace" "aml" {
  name                    = "${var.prefix}-aml-workspace"
  location                = azurerm_resource_group.ml_rg.location
  resource_group_name     = azurerm_resource_group.ml_rg.name
  application_insights_id = azurerm_application_insights.ml_ai.id
  key_vault_id            = azurerm_key_vault.ml_kv.id
  storage_account_id      = azurerm_storage_account.ml_storage.id
  container_registry_id   = azurerm_container_registry.ml_acr.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# 6. Auto-scaling GPU/CPU Compute Cluster for Model Training (0-node cold idle for FinOps)
resource "azurerm_machine_learning_compute_cluster" "train_cluster" {
  name                          = "cpu-train-cluster"
  location                      = azurerm_resource_group.ml_rg.location
  machine_learning_workspace_id = azurerm_machine_learning_workspace.aml.id
  vm_priority                   = "Dedicated"
  vm_size                       = "Standard_DS3_v2"

  scale_settings {
    min_node_count                       = 0 # FinOps: Zero cost when no jobs are active
    max_node_count                       = 4
    scale_down_nodes_after_idle_duration = "PT15M" # Auto shut down after 15 mins idle
  }

  identity {
    type = "SystemAssigned"
  }
}

