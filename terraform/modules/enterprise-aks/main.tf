/**
 * Enterprise Production AKS Module
 * Zero-Trust Private Cluster with Azure CNI Overlay & Workload Identity
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

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.cluster_name
  location                = azurerm_resource_group.aks_rg.location
  resource_group_name     = azurerm_resource_group.aks_rg.name
  dns_prefix_private_cluster = "${var.cluster_name}-priv"
  private_cluster_enabled = true # Zero-Trust: Private API Server
  sku_tier                = "Standard"
  oidc_issuer_enabled     = true
  workload_identity_enabled = true

  default_node_pool {
    name                = "systempool"
    node_count          = var.system_node_count
    vm_size             = "Standard_D4s_v5"
    vnet_subnet_id      = var.aks_subnet_id
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 6
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    zones               = ["1", "2", "3"]

    node_labels = {
      "nodepool" = "system"
      "tier"     = "control"
    }

    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "azure"
    dns_service_ip      = "172.16.0.10"
    service_cidr        = "172.16.0.0/16"
    load_balancer_sku   = "standard"
    outbound_type       = "userDefinedRouting" # Egress routed via Azure Firewall
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

# Dedicated User Node Pool for Production Workloads
resource "azurerm_kubernetes_cluster_node_pool" "user_workloads" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D8s_v5"
  vnet_subnet_id        = var.aks_subnet_id
  enable_auto_scaling   = true
  min_count             = 2
  max_count             = 10
  zones                 = ["1", "2", "3"]

  node_labels = {
    "workload"    = "production"
    "environment" = "prod"
  }

  tags = var.tags
}

