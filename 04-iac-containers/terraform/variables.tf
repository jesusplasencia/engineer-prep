variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_name" {
  description = "Primary PostgreSQL database name"
  type        = string
  default     = "prep_db"
}

variable "db_username" {
  description = "PostgreSQL master admin username"
  type        = string
  default     = "prep_admin"
}

