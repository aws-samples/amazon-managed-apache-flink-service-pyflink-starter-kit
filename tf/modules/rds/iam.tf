resource "aws_iam_role" "rds_role" {
  name        = "${var.kda_application_name}-rds-role"
  description = "IAM role for the KDA Application"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonKinesisFullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "rds.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}
output "rds_role_arn" {
  value = "${aws_iam_role.rds_role.arn}"
}