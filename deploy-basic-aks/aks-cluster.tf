data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

data "azurerm_user_assigned_identity" "example" {
  name                = "aks-basic-tf-dev"      # Replace with the name of your existing user-assigned identity
  resource_group_name = "aks-basic-tf-identity" # Replace with the resource group name where the identity is located
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "example" {
  location            = data.azurerm_resource_group.example.location
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  resource_group_name = data.azurerm_resource_group.example.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  # node_resource_group  = data.azurerm_resource_group.example.name # Use the same resource group as AKS

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.example.id]
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_B2s"
    node_count = var.node_count
  }

  linux_profile {
    admin_username = var.username
    ssh_key {
      #key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
      key_data = tls_private_key.main.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

# Create an Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.example.location
  sku                 = "Basic"
}

# Retrieve the AKS cluster's client ID and server ID
data "azurerm_kubernetes_cluster" "aks" {
  name                = azurerm_kubernetes_cluster.example.name
  resource_group_name = var.resource_group_name
}

# resource "azurerm_role_assignment" "example" {
#   principal_id                     = data.azurerm_user_assigned_identity.example.principal_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# }


# resource "azurerm_role_assignment" "example" {
#   principal_id                     = azurerm_kubernetes_cluster.example.service_principal[0].client_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# }

