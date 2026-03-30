variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project, used to prefix resource names"
  type        = string
  default     = "academyapp"
}

variable "environment" {
  description = "Deployment environment (staging | production)"
  type        = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be 'staging' or 'production'."
  }
}

variable "db_instance_class" {
  description = "RDS instance class for PostgreSQL"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for the PostgreSQL database"
  type        = string
  default     = "academyapp"
}

variable "db_password" {
  description = "Master password for the PostgreSQL database"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 16
    error_message = "db_password must be at least 16 characters long."
  }
}

variable "db_engine_version" {
  description = "PostgreSQL engine version for the RDS instance"
  type        = string
  default     = "15"
}

variable "redis_engine_version" {
  description = "Redis engine version for the ElastiCache cluster"
  type        = string
  default     = "7.0"
}

variable "api_ingress_cidr" {
  description = "CIDR block allowed to reach the API on port 3000. Restrict to your load balancer or VPN range."
  type        = string
  default     = "10.0.0.0/16"
}
