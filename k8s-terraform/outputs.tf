output "namespace" {
  description = "Kubernetes namespace name"
  value       = module.namespace.name
}

output "service_name" {
  description = "Kubernetes service name"
  value       = module.app.service_name
}

output "service_url" {
  description = "URL to access the application"
  value       = "http://localhost:30080"
}

output "deployment_name" {
  description = "Kubernetes deployment name"
  value       = module.app.deployment_name
}