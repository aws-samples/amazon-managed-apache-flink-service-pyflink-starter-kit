variable "environment" {
  type = string
}

variable "aws_region" {
  description = "AWS region where the resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "aws_account" {
  type        = string
  description = "Numerical ID of AWS Account"
}


variable "vpc_rds_subnet_ids"  {
  description = "Subnets"
  type = list
}

variable "vpc_rds_security_group_id"  {
  description = "Security Group ID"
  type = list
}
variable "data_pipeline_bucket_name" {
  type = string
}

variable "kda_application_name" {
  type = string
}

variable "input_stream_name" {
    type = string
}

variable "data_pipeline_bucket_arn" {
  type = string
}

variable "rds_host_endpoint_name" {
  type = string
}

variable "rds_master_username" {
  description = "Database username"
  type = string
}

variable "rds_master_password" {  
  description = "Database password"
  type = string
}

variable "kda_application_aurora_name" {
  description = "aurora cluster name"
  type = string
}