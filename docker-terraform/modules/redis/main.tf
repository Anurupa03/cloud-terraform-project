terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "redis" {
  name = "redis:7-alpine"
}

resource "docker_container" "redis" {
  name  = "redis_cache"
  image = docker_image.redis.image_id

  ports {
    internal = 6379
    external = 6379
  }

  networks_advanced {
    name = var.network_name
  }

  command = ["redis-server", "--appendonly", "yes"]
}