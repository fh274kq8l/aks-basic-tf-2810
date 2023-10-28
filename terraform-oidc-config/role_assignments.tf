data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "example" {
  for_each             = { for env in var.environments : env => env }
  scope                = azurerm_resource_group.example[each.value].id
  role_definition_name = "Contributor"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.example[each.value].principal_id : azuread_service_principal.github_oidc[each.value].id
}

resource "azurerm_role_assignment" "managed_identity_operator" {
  for_each             = { for env in var.environments : env => env }
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.use_managed_identity ? azurerm_user_assigned_identity.example[each.value].principal_id : azuread_service_principal.github_oidc[each.value].id
}

# resource "azurerm_role_assignment" "acr_pull" {
#   principal_id                     = data.azurerm_user_assigned_identity.example.principal_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# }
