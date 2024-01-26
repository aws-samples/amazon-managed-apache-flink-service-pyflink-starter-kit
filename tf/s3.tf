module "s3" {
  source                = "./modules/s3"
  environment           = var.environment
  aws_account           = var.aws_account
  aws_region            = var.aws_region
  kda_application_bucket_name = var.kda_application_bucket_name

}



