terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "backend" {
  name = "backend-app:latest"
  build {
    context    = "${path.root}/backend-app"
    dockerfile = "Dockerfile"
    tag        = ["backend-app:latest"]
  }
}

resource "docker_container" "backend" {
  name  = "backend_service"
  image = docker_image.backend.image_id

  env = [
    "DB_HOST=${var.db_host}",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}"
  ]
  
  ports {
    internal = 5000
    external = 5000
  }

  networks_advanced {
    name = var.network_name
  }

}


