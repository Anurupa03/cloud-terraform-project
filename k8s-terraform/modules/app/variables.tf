variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 2
}