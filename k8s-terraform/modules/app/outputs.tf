output "service_name" {
  description = "Kubernetes service name"
  value       = kubernetes_service.nginx.metadata[0].name
}

output "deployment_name" {
  description = "Kubernetes deployment name"
  value       = kubernetes_deployment.nginx.metadata[0].name
}

output "configmap_name" {
  description = "ConfigMap name"
  value       = kubernetes_config_map.nginx_config.metadata[0].name
}