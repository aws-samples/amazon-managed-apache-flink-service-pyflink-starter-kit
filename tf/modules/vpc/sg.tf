resource "aws_security_group" "allowed-ssh" {
    vpc_id = aws_vpc.main.id
    name = "${var.project_tag}-allowed-ssh"
    description = "security group to allow ssh and all egress traffic"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ingress {
    #     from_port = 0
    #     to_port = 65535
    #     protocol = "-1"
    #     cidr_blocks = ["0.0.0.0/0"]
    # }

    tags = {
        Name =  "${var.project_tag}-allowed-ssh"
    }
}

resource "aws_security_group_rule" "sec_group_allow_tcp" {
  type              = "ingress"
  from_port         = 0 // first part of port range 
  to_port           = 65535 // second part of port range
  protocol          = "-1" // Protocol, could be "tcp" "udp" etc. 
  security_group_id = "${aws_security_group.allowed-ssh.id}" // Which group to attach it to
  source_security_group_id = "${aws_security_group.allowed-ssh.id}" // Which group to specify as source
}

output "vpc_security_group_id" {
  value = ["${aws_security_group.allowed-ssh.id}"]
}