terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.6.2"
        }
    }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_network" {
  name = "app_network"
  driver = "bridge"
}



module "redis" {
  source = "./modules/redis"
  
  network_name = docker_network.app_network.name
}

module "database" {
  source = "./modules/database"

  db_name      = var.db_name
  db_user      = var.db_user
  db_password  = var.db_password
  network_name = docker_network.app_network.name
}

module "backend" {
  source = "./modules/backend"

  db_host               = module.database.db_host
  db_name               = var.db_name
  db_user               = var.db_user
  db_password           = var.db_password
  network_name          = docker_network.app_network.name
  db_container_name     = module.database.container_name
  redis_host            = module.redis.redis_host           # Redis addition
  redis_container_name  = module.redis.container_name       # Redis addition
}

module "frontend" {
  source = "./modules/frontend"

  network_name           = docker_network.app_network.name
  backend_host           = module.backend.container_name
  backend_container_name = module.backend.container_name
  external_port          = var.frontend_port
}