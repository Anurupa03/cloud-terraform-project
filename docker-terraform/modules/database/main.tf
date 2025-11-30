terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "3.6.2"
        }
    }
}

resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_container" "postgres" {
  name  = "postgres_db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name = var.network_name
  }

  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}