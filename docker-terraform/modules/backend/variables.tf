variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "network_name" {
  description = "Docker network name"
  type        = string
}

variable "db_container_name" {
  description = "Database container name for dependency"
  type        = string
}


variable "redis_host" {
  description = "Redis host"
  type        = string
}

variable "redis_container_name" {
  description = "Redis container name for dependency"
  type        = string
}