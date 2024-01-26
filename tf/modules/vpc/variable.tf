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

variable "project_tag" {
  description = "project tag"
  type = string
}

variable "vpc_name" {
  description = "vpc name"
  type = string
}

variable "subnet_name" {
  description = "subnet name"
  type = string
}
