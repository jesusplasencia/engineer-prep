variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Subnets for the RDS subnet group"
  type        = list(string)
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

