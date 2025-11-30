output "frontend_url" {
  description = "Frontend URL"
  value       = module.frontend.frontend_url
}

output "backend_url" {
  description = "Backend API URL"
  value       = module.backend.backend_url
}
