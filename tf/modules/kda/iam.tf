resource "aws_iam_role" "kda_role" {
  name        = "${var.kda_application_name}-role"
  description = "IAM role for the KDA Application"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonKinesisFullAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
    aws_iam_policy.kda_execution.arn
  ]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "kinesisanalytics.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

}

resource "aws_iam_policy" "kda_execution" {
  name   = "${var.kda_application_name}-policy"
  path   = "/"
  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"kinesis:SubscribeToShard",
				"secretsmanager:DescribeSecret",
				"logs:DescribeLogGroups",
				"kinesis:DescribeStreamConsumer",
				"kinesis:GetShardIterator",
				"kinesis:DescribeStream",
				"secretsmanager:ListSecretVersionIds",
				"kinesis:ListTagsForStream",
				"s3:GetObject",
				"secretsmanager:GetResourcePolicy",
				"secretsmanager:GetSecretValue",
				"kinesis:DescribeStreamSummary",
				"kinesis:GetRecords",
				"kinesis:ListStreamConsumers",
				"s3:GetObjectVersion"
			],
			"Resource": [
				"arn:aws:kinesis:${var.aws_region}:${var.aws_account}:stream/${var.input_stream_name}/*",
				"arn:aws:s3:::${var.data_pipeline_bucket_name}/kda_zip/*",
				"arn:aws:s3:::${var.data_pipeline_bucket_name}/*",
				"arn:aws:logs:us-east-1:${var.aws_region}:${var.aws_account}:log-group:*"
			]
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "logs:DescribeLogStreams",
			"Resource": "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/kinesis-analytics/${var.kda_application_name}:log-stream:*"
		},
		{
			"Sid": "VisualEditor2",
			"Effect": "Allow",
			"Action": "logs:PutLogEvents",
			"Resource": "arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/kinesis-analytics/${var.kda_application_name}:log-stream:kinesis-analytics-log-stream"
		},
		{
			"Sid": "VisualEditor3",
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterface",
				"kinesis:ListStreams",
				"ec2:DescribeNetworkInterfaces",
				"rds:*",
				"ec2:CreateNetworkInterfacePermission",
				"ec2:DescribeVpcs",
				"kinesis:ListShards",
				"ec2:DeleteNetworkInterface",
				"ec2:DescribeDhcpOptions",
				"ec2:DescribeSubnets",
				"kinesis:DescribeLimits",
				"ec2:DescribeSecurityGroups"
			],
			"Resource": "*"
		}

	]
}
EOF
}


