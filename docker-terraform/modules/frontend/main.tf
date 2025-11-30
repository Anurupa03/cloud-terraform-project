terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "nginx" {
  name  = "frontend_nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }

  networks_advanced {
    name = var.network_name
  }

  upload {
    content = templatefile("${path.module}/nginx.conf.tpl", {
      backend_host = var.backend_host
    })
    file = "/etc/nginx/conf.d/default.conf"
  }

  depends_on = [var.backend_container_name]
}