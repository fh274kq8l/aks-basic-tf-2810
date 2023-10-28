resource "azurerm_resource_group" "state" {
  name     = "${var.prefix}-state"
  location = var.location
}

resource "azurerm_resource_group" "identity" {
  name     = "${var.prefix}-identity"
  location = var.location
}

resource "azurerm_resource_group" "example" {
  for_each = { for env in var.environments : env => env }
  name     = "${var.prefix}-${each.value}"
  location = var.location
}

