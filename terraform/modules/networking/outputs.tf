output "hub_vnet_id" {
  description = "The ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub_vnet.id
}

output "hub_vnet_name" {
  description = "The Name of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub_vnet.name
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall for UDR routing"
  value       = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.fw_pip.ip_address
}

output "spoke_route_table_id" {
  description = "ID of the route table to associate with spoke subnets"
  value       = azurerm_route_table.spoke_udr.id
}

