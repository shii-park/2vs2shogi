# リソースグループ
resource "azurerm_resource_group" "rg" {
    name = "${var.project_name}-rg"
    location = var.location
}

# Azure Container Registry
resource "azurerm_container_registry" "acr"{
    name = "${var.project_name}arc"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    sku = "Basic"
    admin_enabled = true
}

# Redis
resource "azurerm_redis_cache" "redis"{
    name = "hackathon-winterkosen-redis"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    capacity = 0
    family = "C"
    sku_name = "Basic"
    non_ssl_port_enabled = false
}
