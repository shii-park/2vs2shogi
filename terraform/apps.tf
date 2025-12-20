# ログ分析
resource "azurerm_log_analytics_workspace" "log"{
    name = "${var.project_name}-log"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    sku = "PerGB2018"
    retention_in_days = 30
}

# Container App Enviroment
resource "azurerm_container_app_environment" "env"{
    name = "${var.project_name}-env"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id    
}

# Backend App
resource "azurerm_container_app" "backend" {
  name                         = "backend-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 5
    container {
      name   = "backend"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "REDIS_HOST"
        value = azurerm_redis_cache.redis.hostname
      }
      env {
        name        = "REDIS_PASSWORD"
        secret_name = "redis-password"
      }
      env {
        name  = "REDIS_PORT"
        value = azurerm_redis_cache.redis.ssl_port
      }
    }
  }
  secret {
    name  = "redis-password"
    value = azurerm_redis_cache.redis.primary_access_key
  }
  ingress {
    external_enabled = true
    target_port = 8080
    transport   = "auto"

    traffic_weight {
        percentage = 100
        latest_revision=true
    }
  }
}

# Frontend App
resource "azurerm_container_app" "frontend" {
  name                         = "frontend-app"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 5
    container {
      name   = "frontend"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "NEXT_PUBLIC_API_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }
    }
  }
  ingress {
    external_enabled    = true
    target_port = 3000
    transport   = "auto"

    traffic_weight {
        percentage = 100
        latest_revision=true
    }
  }
}