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


variable "vpc_rds_subnet_ids" {
  description = "kda application name"
  type = list
}

variable "vpc_rds_security_group_id" {
  description = "kda application name"
  type = list
}

variable "kda_application_name" {
  description = "kda application name"
  type = string
}