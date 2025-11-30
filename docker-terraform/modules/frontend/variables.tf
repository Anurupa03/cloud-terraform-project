variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "backend_host" {
  description = "Backend container hostname"
  type        = string
}

variable "backend_container_name" {
  description = "Backend container name for dependency"
  type        = string
}

variable "external_port" {
  description = "External port for nginx"
  type        = number
  default     = 8080
}