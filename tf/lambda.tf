module "lambda" {
  source                = "./modules/lambda"
  environment           = var.environment
  aws_account           = var.aws_account
  aws_region            = var.aws_region
  rds_master_username = var.rds_master_username
  rds_master_password = var.rds_master_password
  kda_application_aurora_name = var.kda_application_aurora_name 
  vpc_rds_subnet_ids = module.vpc.vpc_subnet_id
  vpc_rds_security_group_id = module.vpc.vpc_security_group_id
  kda_application_name = var.kda_application_name
  data_pipeline_bucket_name = var.kda_application_bucket_name
  data_pipeline_bucket_arn = module.s3.kda_application_bucket_arn
  rds_host_endpoint_name = module.rds.rds_proxy_endpoint
  input_stream_name = module.kds.kda_input_stream_name
  rds_role_arn = module.rds.rds_role_arn
}