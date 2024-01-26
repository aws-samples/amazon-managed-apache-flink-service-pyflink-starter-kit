variable "aws_region" {
  description = "AWS region where the resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment being deployed"
  type        = string
  default     = "dev"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "datazone2"
}

variable "aws_account" {
  description = "AWS account"
  type        = string
  default     = ""
}

variable "deployment_team" {
  description = "Deployment team name"
  type = string
  default     = "aws-proserve"
}

variable "project_tag" {
  description = "project tag"
  type = string
  default = "epic-stats"
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "subnet_name" {
  description = "subnet name"
  type = string
}

variable "kda_application_bucket_name" {
  description = "bucket to store kda application data"
  type = string
  default = "epic-stats"
}

variable "kda_application_name" {
  description = "kda application name"
  type = string
}

variable "kda_application_aurora_name" {
  description = "kda application rds db name"
  type = string
}

variable "input_stream_name" {
  description = "kinesis stream name"
  type = string
}

variable "rds_master_username" {
   description = "rds master username"
  type = string
}

variable "rds_master_password" {
   description = "rds master password"
  type = string
}
