module "kds" {
  source                = "./modules/kds"
  environment           = var.environment
  aws_account           = var.aws_account
  aws_region            = var.aws_region
  input_stream_name     = var.input_stream_name
}