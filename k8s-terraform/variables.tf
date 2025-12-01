variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}