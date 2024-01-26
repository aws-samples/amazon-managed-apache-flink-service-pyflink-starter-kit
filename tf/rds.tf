module "rds" {
  source                = "./modules/rds"
  environment           = var.environment
  aws_account           = var.aws_account
  aws_region            = var.aws_region
  rds_master_username = var.rds_master_username
  rds_master_password = var.rds_master_password
  kda_application_aurora_name = var.kda_application_aurora_name
  vpc_rds_subnet_ids = module.vpc.vpc_subnet_id
  vpc_rds_security_group_id = module.vpc.vpc_security_group_id
  kda_application_name = var.kda_application_name
}