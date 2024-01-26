# #layer zip file
# data "archive_file" "aws_layer" {
#     type = "zip"
#     source_dir = "${path.root}/../lambda_code/layer"
#     output_path = "lambda_layer.zip"
# }

data "archive_file" "kda_sql_function" {
    type = "zip"
    source_dir = "${path.root}/../lambda_code/kda-pyflink-starter-sql-function"
    output_path = "${path.root}/../lambda_code/kda-pyflink-starter-sql-function.zip"
}

# resource "aws_lambda_layer_version" "lambda_layer_psycopg" {
#   filename            = "${path.root}/../lambda_code/layer/dependencies.zip"
#   layer_name          = "lambda_layer_psycopg"
#   compatible_architectures = ["x86_64"]
# }

resource "aws_lambda_layer_version" "lambda_layer_psycopg" {
  layer_name          = "lambda_layer_psycopg"
  s3_bucket        = var.data_pipeline_bucket_name
	s3_key           = "layer/dependancies.zip"
  compatible_architectures = ["x86_64"]
}


resource "aws_lambda_function" "kda_sql_function" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${data.archive_file.kda_sql_function.output_path}"
  function_name = "kda-pyflink-starter-sql-function"
  role          = var.rds_role_arn
  handler       = "lambda_function.lambda_handler"
  layers        = [aws_lambda_layer_version.lambda_layer_psycopg.arn]


  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("${data.archive_file.kda_sql_function.output_path}")

  runtime = "python3.8"

  environment {
    variables = {
      db_host = var.rds_host_endpoint_name
      db_port = "5432"
      db_username = var.rds_master_username
      db_password = var.rds_master_password
      db_database = "dev"
    }
  }
    vpc_config {
    subnet_ids = var.vpc_rds_subnet_ids
    security_group_ids = "${var.vpc_rds_security_group_id}" 
  }

}