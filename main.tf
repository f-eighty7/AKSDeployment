terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Define Azure resource group
resource "azurerm_resource_group" "devops-demo-rg" {
  name     = "devops-demo-rg"
  location = "westeurope"
}

# Define Azure Kubernetes Service (AKS) cluster
resource "azurerm_kubernetes_cluster" "devops-demo-aks-cluster" {
  name                = "devops-demo-aks-cluster"
  location            = azurerm_resource_group.devops-demo-rg.location
  resource_group_name = azurerm_resource_group.devops-demo-rg.name
  dns_prefix          = "devops-demo-aks-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Dev"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.devops-demo-aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.devops-demo-aks-cluster.kube_config_raw
  sensitive = true
}
