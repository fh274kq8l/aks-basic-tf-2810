variable "resource_group_name" {
  type = string
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

# variable "aks_cluster_name" {
#   type = string
#   description = "AKS cluster name"
#   default = "aks-cluster-1601"
# }

variable "acr_name" {
  type = string
  description = "ACR name"
  default = "<acrName>"
}