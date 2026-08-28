# ==============================================================================
# Main Terraform Composition
# Assembles modular VPC and RDS Database components into a resilient architecture
# ==============================================================================

module "vpc" {
  source = "./modules/vpc"

  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "database" {
  source = "./modules/database"

  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name            = var.db_name
  db_username        = var.db_username
}

