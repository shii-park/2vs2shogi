output "frontend_url" {
  value = azurerm_container_app.frontend.ingress[0].fqdn
}

output "backend_url" {
  value = azurerm_container_app.backend.ingress[0].fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}