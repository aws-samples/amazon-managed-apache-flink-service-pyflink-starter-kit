resource "aws_s3_bucket" "kda_application_bucket" {
  bucket = var.kda_application_bucket_name

 
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.kda_application_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "kda_application_bucket" {
  bucket = aws_s3_bucket.kda_application_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_public_access_block" "kda_application_bucket" {
  bucket                  = aws_s3_bucket.kda_application_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "kda_application_bucket_arn" {
  value = "${aws_s3_bucket.kda_application_bucket.arn}"
}

output "kda_application_bucket_name" {
  value = "${aws_s3_bucket.kda_application_bucket}"
}