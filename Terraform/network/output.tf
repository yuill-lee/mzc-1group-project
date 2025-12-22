output "vpc" {
    value = aws_vpc.vpc
}
output "vpc-id" {
    value = aws_vpc.vpc.id
}

output "public-subnet-1-id" {
    value = aws_subnet.pub-1.id
}

output "public-subnet-2-id" {
    value = aws_subnet.pub-2.id
}

output "private-subnet-1-id" {
    value = aws_subnet.priv-1.id
}

output "private-subnet-2-id" {
    value = aws_subnet.priv-2.id
}

output "web-sg-id" {
    value = aws_security_group.web-sg.id
}

output "was-sg-id" {
    value = aws_security_group.was-sg.id
}

output "db-sg-id" {
    value = aws_security_group.db-sg.id
}

output "bastion-sg-id" {
    value = aws_security_group.bastion-sg.id
}

output "nat-sg-id" {
    value = aws_security_group.nat-sg.id
}

output "public_alb_sg_id" {
    value = aws_security_group.public-alb-sg.id
}

output "internal_alb_sg_id" {
    value = aws_security_group.internal-alb-sg.id
}
