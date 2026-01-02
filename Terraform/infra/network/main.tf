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

resource "aws_subnet" "pub_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.az.names[0]

    tags = {
        Name = "Public_Subnet_1"
    }
}

resource "aws_subnet" "pub_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.az.names[1]

    tags = {
        Name = "Public_Subnet_2"
    }
}

resource "aws_subnet" "priv_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.11.0/24"
    availability_zone = data.aws_availability_zones.az.names[0]

    tags = {
        Name = "Private_Subnet_1"
    }
}

resource "aws_subnet" "priv_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.12.0/24"
    availability_zone = data.aws_availability_zones.az.names[1]

    tags = {
        Name = "Private_Subnet_2"
    }
}
# -------------------- Subnet -------------------- #
# -------------------- Route Table -------------------- #
resource "aws_route_table" "public_rt"{
   vpc_id = aws_vpc.vpc.id

   tags = {
        Name = "Public Route Table"
   } 
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "Private Route Table"
    }
}

// public route table에 default route로 igw 추가
resource "aws_route" "public_rt_internet" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

// private route table에 default route로 nat instance 추가
resource "aws_route" "private_rt_nat" {
    route_table_id = aws_route_table.private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = var.nat_instance_eni_id
}

// route table에 subnet associate
resource "aws_route_table_association" "public_rt_association_1"{
    subnet_id = aws_subnet.pub_1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association_2"{
    subnet_id = aws_subnet.pub_2.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association_1"{
    subnet_id = aws_subnet.priv_1.id
    route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association_2"{
    subnet_id = aws_subnet.priv_2.id
    route_table_id = aws_route_table.private_rt.id
}
# -------------------- Route Table -------------------- #
# -------------------- Security Groups -------------------- #
resource "aws_security_group" "web_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "WEB-SG"

    tags = {
        Name = "WEB-SG"
    }
}

resource "aws_security_group" "was_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "WAS-SG"

    tags = {
        Name = "WAS-SG"
    }
}

resource "aws_security_group" "db_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "DB-SG"

    tags = {
        Name = "DB-SG"
    }
}

resource "aws_security_group" "bastion_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Bastion-SG"

    tags = {
        Name = "Bastion-SG"
    }
}

resource "aws_security_group" "nat_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "NAT-SG"

    tags = {
        Name = "NAT-SG"
    }
}

resource "aws_security_group" "alb_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "ALB-SG"

    tags = {
        Name = "ALB-SG"
    }
}

resource "aws_security_group" "public_alb_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Public-ALB-SG"

    tags = {
        Name = "Public-ALB-SG"
    }
}

resource "aws_security_group" "internal_nlb_sg"{
    vpc_id = aws_vpc.vpc.id
    name = "Internal-NLB-SG"

    tags = {
        Name = "Internal-NLB-SG"
    }
}
resource "aws_vpc_security_group_ingress_rule" "web_ingress_allow_http" {
    security_group_id = aws_security_group.web_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web_ingress_allow_https" {
    security_group_id = aws_security_group.web_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web_ingress_allow_ssh" {
    security_group_id = aws_security_group.web_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "web_egress_allow_all" {
    security_group_id = aws_security_group.web_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "was_ingress_allow_php" {
    security_group_id = aws_security_group.was_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 9000
    to_port = 9000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "was_ingress_allow_ssh" {
    security_group_id = aws_security_group.was_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "was_egress_allow_all" {
    security_group_id = aws_security_group.was_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "db_ingress_allow_mysql" {
    security_group_id = aws_security_group.db_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 3306
    to_port = 3306
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "db_egress_allow_all" {
    security_group_id = aws_security_group.db_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ingress_allow_ssh" {
    security_group_id = aws_security_group.bastion_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "bastion_egress_allow_all" {
    security_group_id = aws_security_group.bastion_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "nat_ingress_allow_ssh" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat_ingress_allow_http" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat_ingress_allow_https" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "nat_ingress_allow_dns_udp" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 53
    to_port = 53
    ip_protocol = "udp"
}

resource "aws_vpc_security_group_ingress_rule" "nat_ingress_allow_dns_tcp" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 53
    to_port = 53
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "nat_egress_allow_all" {
    security_group_id = aws_security_group.nat_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_allow_http" {
    security_group_id = aws_security_group.alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_allow_https" {
    security_group_id = aws_security_group.alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_allow_all" {
    security_group_id = aws_security_group.alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "public_alb_ingress_allow_http" {
    security_group_id = aws_security_group.public_alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "public_alb_ingress_allow_https" {
    security_group_id = aws_security_group.public_alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "public_alb_egress_allow_all" {
    security_group_id = aws_security_group.public_alb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "internal_nlb_ingress_allow_php" {
    security_group_id = aws_security_group.internal_nlb_sg.id
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    from_port = 9000
    to_port = 9000
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "internal_nlb_egress_allow_all" {
    security_group_id = aws_security_group.internal_nlb_sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
# -------------------- Security Groups -------------------- #
