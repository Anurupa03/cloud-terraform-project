variable "name" {
  description = "Namespace name"
  type        = string
}

variable "environment" {
  description = "Environment label"
  type        = string
  default     = "dev"
}