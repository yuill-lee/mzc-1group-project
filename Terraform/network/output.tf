output "vpc" {
    value = aws_vpc.vpc
}

output "public-subnet-1-id" {
    value = aws_subnet.pub-1.id
}

output "public-subnet-2-id" {
    value = aws_subnet.pub-2
}

output "private-subnet-1" {
    value = aws_subnet.priv-1
}

output "private-subnet-2" {
    value = aws_subnet.priv-2
}

output "web-sg" {
    value = aws_security_group.web-sg
}

output "was-sg" {
    value = aws_security_group.was-sg
}

output "db-sg" {
    value = aws_security_group.db-sg
}

output "bastion-sg-id" {
    value = aws_security_group.bastion-sg.id
}

output "nat-sg-id" {
    value = aws_security_group.nat-sg.id
}

output "alb-sg" {
    value = aws_security_group.alb-sg
}