resource "aws_rds_cluster" "aurora_cluster" {

    cluster_identifier            = "${var.kda_application_aurora_name}"
    engine                        = "aurora-postgresql"
    database_name                 = "dev"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    final_snapshot_identifier     = "${var.kda_application_aurora_name}-snapshot-cluster"
    vpc_security_group_ids        = "${var.vpc_rds_security_group_id}"

    lifecycle {
        create_before_destroy = true
    }

}
# "db.r5.24xlarge"
resource "aws_rds_cluster_instance" "writer" {
  engine               = aws_rds_cluster.aurora_cluster.engine
  engine_version       = "15.3"
  identifier           = "${var.kda_application_aurora_name}-instance-1"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.r5.xlarge"
  db_subnet_group_name = "${aws_db_subnet_group.aurora_subnet_group.name}"
}

resource "aws_rds_cluster_instance" "reader" {
  engine               = aws_rds_cluster.aurora_cluster.engine
  engine_version       = "15.3"
  identifier           = "${var.kda_application_aurora_name}-instance-2"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.r5.xlarge"
  db_subnet_group_name = "${aws_db_subnet_group.aurora_subnet_group.name}"
}


resource "aws_db_subnet_group" "aurora_subnet_group" {

    name          = "${var.kda_application_aurora_name}_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = var.vpc_rds_subnet_ids


}

output "rds_proxy_endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.endpoint}"
}

