/**
 * Enterprise Hub Networking Module
 * Microsoft Cloud Adoption Framework (CAF) Aligned
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

resource "azurerm_resource_group" "hub_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.prefix}-hub-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = [var.hub_vnet_cidr]
  tags                = var.tags
}

# Subnets with strict isolation
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 2, 0)] # /26 required for FW
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 3, 2)] # /27 for Bastion
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [cidrsubnet(var.hub_vnet_cidr, 3, 3)] # /27 for VPN/ExpressRoute
}

# Azure Firewall Public IP
resource "azurerm_public_ip" "fw_pip" {
  name                = "${var.prefix}-firewall-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# Azure Firewall Premium Policy (IDPS & TLS Inspection)
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "${var.prefix}-fw-policy"
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  sku                 = "Premium"
  threat_intelligence_mode = "Deny"

  intrusion_detection {
    mode = "Deny"
  }

  tags = var.tags
}

# Azure Firewall Instance with Premium Tier
resource "azurerm_firewall" "hub_fw" {
  name                = "${var.prefix}-azure-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id
  zones               = ["1", "2", "3"]

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }

  tags = var.tags
}

# Route Table for Spoke Force-Tunneling (Zero-Trust Default Route)
resource "azurerm_route_table" "spoke_udr" {
  name                          = "${var.prefix}-spoke-to-hub-udr"
  location                      = azurerm_resource_group.hub_rg.location
  resource_group_name           = azurerm_resource_group.hub_rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "Default-Route-To-Firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }

  tags = var.tags
}

