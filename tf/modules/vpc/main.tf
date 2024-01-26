resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/25"  #126 IP 10.0.0.0 - 10.0.0.127
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id = aws_vpc.main.id
  cidr_block =  "10.0.0.0/27" #32 IP 10.0.0.0 - 10.0.0.31
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.subnet_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id = aws_vpc.main.id
  cidr_block =  "10.0.0.32/27" #32 10.0.0.32 - 10.0.0.63
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.subnet_name}-private-subnet-2"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.64/27" #32 IP 	10.0.0.64 - 10.0.0.95
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.subnet_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.96/27" #32 10.0.0.96 - 10.0.0.127
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1d"

  tags = {
    Name = "${var.subnet_name}-public-subnet-2"
  }
}



resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.subnet_name}-internet-gw"
  }
  
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
  
}


resource "aws_route_table_association" "public-rta-1" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-rta-2" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}

output "private-subnet-1" {
  value = "${aws_subnet.private-subnet-1.id}"
}


output "private-subnet-2" {
  value = "${aws_subnet.private-subnet-2.id}"
}

output "public-subnet-1" {
  value = "${aws_subnet.public-subnet-1.id}"
}


output "public-subnet-2" {
  value = "${aws_subnet.public-subnet-2.id}"
}


################################
# NAT
################################

resource "aws_eip" "nat" {
  domain  = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_internet_gateway.internet-gw]
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
}

resource "aws_route_table_association" "private-rta" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}


output "vpc_subnet_id" {
  value = ["${aws_subnet.private-subnet-1.id}", "${aws_subnet.private-subnet-2.id}"]
}

