module "vpc" {
  source                = "./modules/vpc"
  environment           = var.environment
  aws_account           = var.aws_account
  aws_region            = var.aws_region
  project_tag           = var.project_tag
  vpc_name              = var.vpc_name  
  subnet_name           = var.subnet_name
}