output "container_name" {
  value = docker_container.backend.name
}

output "backend_url" {
  value = "http://localhost:5000"
}