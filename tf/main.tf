terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
  }


backend "s3" {
    bucket = "aws-msk-cluster-bucket"
    key    = "starterkit/state_file"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "${var.aws_profile}"
    default_tags {
    tags = {
      Project     = var.project_tag
      Environment = var.environment
      Deployment  = "Terraform"
      Team        = var.deployment_team
    }
  }
}
