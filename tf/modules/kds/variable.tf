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
variable "input_stream_name" {
    type = string
}
