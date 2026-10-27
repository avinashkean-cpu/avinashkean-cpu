output "workspace_id" {
  description = "The ID of the Azure Machine Learning Workspace"
  value       = azurerm_machine_learning_workspace.aml.id
}

output "workspace_name" {
  description = "The name of the Azure Machine Learning Workspace"
  value       = azurerm_machine_learning_workspace.aml.name
}

output "compute_cluster_id" {
  description = "The ID of the training compute cluster"
  value       = azurerm_machine_learning_compute_cluster.train_cluster.id
}

