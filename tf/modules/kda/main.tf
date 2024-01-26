resource "aws_cloudwatch_log_group" "kda-application-log-group" {
  name = "${var.kda_application_name}"
}

resource "aws_cloudwatch_log_stream" "kda-application-log-stream" {
  name           = "${var.kda_application_name}-stream"
  log_group_name = aws_cloudwatch_log_group.kda-application-log-group.name
}

resource "null_resource" "build_kda_zip" {

triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "${path.root}/zipup.sh"
  
    environment = {
        S3_BUCKET = var.data_pipeline_bucket_name
        KEY = "kda_zip"
      }
    }
}

locals {
  zip_file = fileset("${path.root}/../build/", "*.zip")
  index = length(local.zip_file) > 0 ? regex("V(\\d+)", one(local.zip_file)): ["0"]
  filename = "KdaPyFlinkStarterDataPipeline_V${tonumber(local.index[0])+1}.zip"
}


resource "aws_kinesisanalyticsv2_application" "kda-application" {
  # depends_on = [null_resource.build_kda_zip]
  name                   = "${var.kda_application_name}"
  runtime_environment    = "FLINK-1_15"
  service_execution_role = aws_iam_role.kda_role.arn
  
  cloudwatch_logging_options {
      log_stream_arn = aws_cloudwatch_log_stream.kda-application-log-stream.arn
  }
  application_configuration {
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = "${var.data_pipeline_bucket_arn}"
          file_key   = "kda_zip/${local.filename}"
        }
      }

      code_content_type = "ZIPFILE"
    }

    environment_properties {
        property_group {
          property_group_id = "starter.data.pipeline.config"

          property_map = {
            "aws.region" = "${var.aws_region}"
            "input.stream.name" = "${var.input_stream_name}"
            "flink.stream.initpos": "LATEST"
            "db.host": var.rds_host_endpoint_name
            "db.port":"5432"
            "db.name": "dev"
            "db.username":"gryffindor"
            "db.password":"password2311"
          }
          
        }
        property_group {
          property_group_id = "kinesis.analytics.flink.run.options"

          property_map = {
            "jarfile" = "kda-pyflink-starter-data-pipeline/lib/kda-pyflink-starter-uber.jar"
            "pyFiles" = "kda-pyflink-starter-data-pipeline/dependencies/"
            "python": "kda-pyflink-starter-data-pipeline/starter-data-pipeline.py"
          }
        }
      }


    application_snapshot_configuration {
        snapshots_enabled = false
    }
    
    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = "CUSTOM"
        checkpointing_enabled = false
        checkpoint_interval = 1000
      }



      monitoring_configuration {
        configuration_type = "CUSTOM"
        log_level          = "INFO"
        metrics_level      = "TASK"
        
      }

      parallelism_configuration {
        auto_scaling_enabled = false
        configuration_type   = "CUSTOM"
        parallelism          = 1
        parallelism_per_kpu  = 1
      }
    } 
    vpc_configuration {
      security_group_ids = "${var.vpc_rds_security_group_id}"
      subnet_ids         = var.vpc_rds_subnet_ids
    } 
  }
}

