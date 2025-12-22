# -------------------- VPC -------------------- #
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = "Final-Project-VPC"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "Final-Project-IGW"
    }
}
# -------------------- VPC -------------------- #
# -------------------- Subnet -------------------- #
// 현 리전의 가용영역을 배열로 받아옴
data "aws_availability_zones" "az" {
    state = "available"
}

resource "aws_subnet" "pub-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.az.names[0]

    tags = {
        Name = "Public-Subnet-1"
    }
}

resource "aws_subnet" "pub-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.az.names[1]

    tags = {
        Name = "Public-Subnet-2"
    }
}

resource "aws_subnet" "priv-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.11.0/24"
    availability_zone = data.aws_availability_zones.az.names[0]

    tags = {
        Name = "Private-Subnet-1"
    }
}

resource "aws_subnet" "priv-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.12.0/24"
    availability_zone = data.aws_availability_zones.az.names[1]

    tags = {
        Name = "Private-Subnet-2"
    }
}
# -------------------- Subnet -------------------- #
# -------------------- Route Table -------------------- #
resource "aws_route_table" "public-rt"{
   vpc_id = aws_vpc.vpc.id

   tags = {
        Name = "Public Route Table"
   } 
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "Private Route Table"
    }
}

// public route table에 default route로 igw 추가
resource "aws_route" "public-rt-internet" {
    route_table_id = aws_route_table.public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

// private route table에 default route로 nat instance 추가
resource "aws_route" "private-rt-nat" {
    route_table_id = aws_route_table.private-rt.id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = var.nat-instance-eni-id
}

// route table에 subnet associate
resource "aws_route_table_association" "public-rt-association-1"{
    subnet_id = aws_subnet.pub-1.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-rt-association-2"{
    subnet_id = aws_subnet.pub-2.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-association-1"{
    subnet_id = aws_subnet.priv-1.id
    route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rt-association-2"{
    subnet_id = aws_subnet.priv-2.id
    route_table_id = aws_route_table.private-rt.id
}
# -------------------- Route Table -------------------- #
# -------------------- Security Groups -------------------- #
resource "aws_security_group" "web-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "WEB-SG"

    tags = {
        Name = "WEB-SG"
    }
}

resource "aws_security_group" "was-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "WAS-SG"

    tags = {
        Name = "WAS-SG"
    }
}

resource "aws_security_group" "db-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "DB-SG"

    tags = {
        Name = "DB-SG"
    }
}

resource "aws_security_group" "bastion-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Bastion-SG"

    tags = {
        Name = "Bastion-SG"
    }
}

resource "aws_security_group" "nat-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "NAT-SG"

    tags = {
        Name = "NAT-SG"
    }
}

resource "aws_security_group" "alb-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "ALB-SG"

    tags = {
        Name = "ALB-SG"
    }
}

resource "aws_security_group" "public-alb-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Public-ALB-SG"

    tags = {
        Name = "Public-ALB-SG"
    }
}

resource "aws_security_group" "internal-alb-sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Internal-ALB-SG"

    tags = {
        Name = "Internal-ALB-SG"
    }
}
resource "aws_vpc_security_group_ingress_rule" "web-ingress-allow-http" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web-ingress-allow-https" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web-ingress-allow-ssh" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web-egress-allow-all" {
    security_group_id = aws_security_group.web-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "was-ingress-allow-php" {
    security_group_id = aws_security_group.was-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 9000
    to_port = 9000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "was-ingress-allow-ssh" {
    security_group_id = aws_security_group.was-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "was-egress-allow-all" {
    security_group_id = aws_security_group.was-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db-ingress-allow-mysql" {
    security_group_id = aws_security_group.db-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db-egress-allow-all" {
    security_group_id = aws_security_group.db-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "bastion-ingress-allow-ssh" {
    security_group_id = aws_security_group.bastion-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "bastion-egress-allow-all" {
    security_group_id = aws_security_group.bastion-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "nat-ingress-allow-ssh" {
    security_group_id = aws_security_group.nat-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat-ingress-allow-http" {
    security_group_id = aws_security_group.nat-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat-ingress-allow-https" {
    security_group_id = aws_security_group.nat-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat-ingress-allow-dns-udp" {
    security_group_id = aws_security_group.nat-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 53
    to_port = 53
    ip_protocol = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "nat-ingress-allow-dns-tcp" {
    security_group_id = aws_security_group.nat-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 53
    to_port = 53
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb-ingress-allow-http" {
    security_group_id = aws_security_group.alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb-ingress-allow-https" {
    security_group_id = aws_security_group.alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb-egress-allow-all" {
    security_group_id = aws_security_group.alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "public-alb-ingress-allow-http" {
    security_group_id = aws_security_group.public-alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "public-alb-ingress-allow-https" {
    security_group_id = aws_security_group.public-alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "public-alb-egress-allow-all" {
    security_group_id = aws_security_group.public-alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "internal-alb-ingress-allow-php" {
    security_group_id = aws_security_group.internal-alb-sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 9000
    to_port = 9000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "internal-alb-egress-allow-all" {
    security_group_id = aws_security_group.internal-alb-sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
# -------------------- Security Groups -------------------- #
