output "vpc" {
    value = aws_vpc.vpc
}
output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "public_subnet_1_id" {
    value = aws_subnet.pub_1.id
}

output "public_subnet_2_id" {
    value = aws_subnet.pub_2.id
}

output "private_subnet_1_id" {
    value = aws_subnet.priv_1.id
}

output "private_subnet_2_id" {
    value = aws_subnet.priv_2.id
}

output "web_sg_id" {
    value = aws_security_group.web_sg.id
}

output "was_sg_id" {
    value = aws_security_group.was_sg.id
}

output "db_sg_id" {
    value = aws_security_group.db_sg.id
}

output "bastion_sg_id" {
    value = aws_security_group.bastion_sg.id
}

output "nat_sg_id" {
    value = aws_security_group.nat_sg.id
}

output "public_alb_sg_id" {
    value = aws_security_group.public_alb_sg.id
}

output "internal_alb_sg_id" {
    value = aws_security_group.internal_alb_sg.id
}
