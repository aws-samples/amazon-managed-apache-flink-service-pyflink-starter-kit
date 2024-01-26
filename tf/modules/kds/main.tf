resource "aws_kinesis_stream" "aws_kinesis_stream" {
  name             = var.input_stream_name
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingRecords",
    "IncomingBytes",
    "OutgoingBytes",
    "IteratorAgeMilliseconds",
    "ReadProvisionedThroughputExceeded"
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

}

output "kda_input_stream_name" {
  value = "${aws_kinesis_stream.aws_kinesis_stream.name}"
}